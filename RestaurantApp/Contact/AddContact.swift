//
//  AddContact.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 02/07/25.
//

import Foundation
import SwiftUI
import ContactsUI

struct AddContact:View {
    let user = MainData.shared.user
    @State private var allContacts = [CNContact]()
    @State private var searchText = ""
    var filteredContacts: [CNContact]{
        if searchText.isEmpty{
            allContacts
        }else{
            allContacts.filter{contact in
                let fullName = contact.givenName + " " + contact.familyName
                return fullName.contains(searchText)
            }
        }
    }
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            List(filteredContacts){contact in
                HStack{
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .animation(.linear, value: 3)
                    VStack(alignment: .leading){
                        Text(contact.givenName)
                        Text(contact.familyName)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                .onTapGesture {
                    let contact = Contact(contact: contact)
                    user?.contact.append(contact)
                    dismiss()
                }
            }
            .searchable(text: $searchText)
        }
        .onAppear(){
            getContact()
        }
    }
    func getContact(){
        let CNStore = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            Task{
                let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey as CNKeyDescriptor]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                let idList = user?.contact.map(\.id) ?? []
                try CNStore.enumerateContacts(with: fetchRequest){contact, _ in
                    if !idList.contains(contact.identifier){
                        allContacts.append(contact)
                    }
                }
                allContacts.sort(by: sortContact)
            }
        case .notDetermined:
            CNStore.requestAccess(for: .contacts){granted, error in
                if granted{
                    getContact()
                }else if let error{
                    print(error.localizedDescription)
                }
            }
        default :
            break
        }
    }
    func sortContact(lhs:CNContact, rhs:CNContact)->Bool{
        lhs.givenName < rhs.givenName
    }
}
#Preview {
    AddContact()
}
