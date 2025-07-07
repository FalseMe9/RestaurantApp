//
//  Contact.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 02/07/25.
//
import Foundation
import ContactsUI
struct Contact: Codable, Identifiable{
    var id : String
    var givenName : String
    var familyName : String
    var email : String?
    init(contact : CNContact){
        id = contact.identifier
        givenName = contact.givenName
        familyName = contact.familyName
        email = contact.emailAddresses.first?.value as? String
    }
    
}
