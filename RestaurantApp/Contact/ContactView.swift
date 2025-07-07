//
//  ContentView.swift
//  Friends_Tab
//
//  Created by Billie Hartanto on 27/06/25.
//

import SwiftUI
import ContactsUI

struct ContactView: View {
    let user = MainData.shared.user
    @State private var searchText = ""
    @State private var showSheet = false
    var filteredContacts : [Contact]{
        if searchText.isEmpty{
            user?.contact ?? []
        }else{
            user?.contact.filter {
                $0.givenName.localizedStandardContains(searchText) || $0.familyName.localizedStandardContains(searchText)
            } ?? []
        }
    }
    var body: some View {
        NavigationStack{
            List(filteredContacts){contact in
                ContactItemView(contact: contact)
            }
            .searchable(text: $searchText)
            .toolbar{
                Button{
                    showSheet.toggle()
                }label: {
                    Image(systemName: "plus")
                        .font(.headline.bold())
                        .padding(3)
                        .foregroundStyle(.black)
                        .background(.green)
                        .clipShape(.circle)
                }
            }
        }
        .sheet(isPresented: $showSheet){
            AddContact()
        }
    }
}

struct ContactItemView:View {
    let user = MainData.shared.user
    let contact : Contact
    @State var place : MapItem?
    var body: some View {
        VStack(alignment: .leading){
            Text(contact.givenName)
                .font(.headline.bold())
            if let email = contact.email{
                Text(email)
            }
            if let place{
                Text(place.name)
            }
        }
        .onAppear(perform: getPlace)
        .swipeActions{
            Button{
                if let index = user?.contact.firstIndex(where: {$0.id == contact.id}){
                    user?.contact.remove(at: index)
                }
            }label: {
                Image(systemName: "trash")
                    .fixedSize()
            }
            .tint(.red)
        }
    }
    init(contact: Contact) {
        self.contact = contact
    }
    func getPlace(){
        print("Hallo")
        if let key = contact.email?.asKey{
            print("Hi")
            Task{
                self.place = try await ref.child(key).child("map").getData().data(as: MapItem.self)
            }
        }else{
            self.place = nil
        }
    }
}

#Preview{
    ContactView()
}
