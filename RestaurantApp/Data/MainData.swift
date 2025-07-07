//
//  MainData.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 28/06/25.
//
import FirebaseDatabase
import SwiftUI
@MainActor
@Observable
class MainData{
    var user : UserData?
    var showCoverPage : Bool = true
    static let shared = MainData()
}
let ref = Database.database().reference()
