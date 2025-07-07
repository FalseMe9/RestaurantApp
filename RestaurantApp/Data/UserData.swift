//
//  UserData.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 03/07/25.
//

import Foundation
import FirebaseDatabase
@MainActor
@Observable
class UserData{
    let ref = Database.database().reference()
    var data : AuthDataResultModel
    var contact = [Contact]()
    {didSet{saveContact()}}
    var map : MapItem?
    {didSet{saveMap()}}
    var time : Date?{
        didSet{saveTime()}
    }
    
    init(user: AuthDataResultModel) {
        self.data = user
    }
    func load() async{
        if let key = data.email?.asKey{
            let contact = try? await ref.child(key).child("contact").getData().data(as: [Contact].self)
            self.contact = contact ?? []
            map = try? await ref.child(key).child("map").getData().data(as: MapItem.self)
            if let time = try? await ref.child(key).child("time").getData().data(as: TimeInterval.self){
                self.time = Date(timeIntervalSince1970: time)
            }else{
                self.time = nil
            }
        }
    }
    func saveContact(){
        Task{
            if let key = data.email?.asKey{
                try await UploadHelper.upload(item: contact, ref: ref.child(key).child("contact"))
            }
        }
    }
    func saveTime(){
        Task{
            if let key = data.email?.asKey, let time = time?.timeIntervalSince1970{
                ref.child(key).child("time").setValue(time)
            }
        }
    }
    func saveMap(){
        Task{
            if let key = data.email?.asKey{
                try await UploadHelper.upload(item: map, ref: ref.child(key).child("map"))
            }
        }
    }
    func checkTime(){
        if let time, time < .now{
            map = nil
        }
    }
}
protocol Uploadable : Codable{
    
}


extension String{
    func replace(of target : String, with result : String)->String{
        self.replacingOccurrences(of: target, with: result)
    }
    var asKey : String{
        self.replacingOccurrences(of: ".", with: ",").replace(of: "@", with: "")
    }
}
@MainActor
class UploadHelper{
    static func upload(item : Codable, ref : DatabaseReference) async throws{
        let data = try JSONEncoder().encode(item)
        let dict = try JSONSerialization.jsonObject(with: data)
        try await ref.setValue(dict)
    }
    static var shared = UploadHelper()
}
