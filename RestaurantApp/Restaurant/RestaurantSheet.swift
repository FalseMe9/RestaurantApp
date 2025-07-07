//
//  RestaurantSheet.swift
//  Restaurant_Tab
//
//  Created by Billie Hartanto on 23/06/25.
//

import SwiftUI
import MapKit
struct RestaurantSheet:View {
    @State var item : MapItem
    let user = MainData.shared.user
    let model = RestaurantViewModel.shared
    var body: some View {
        Form{
            Text(item.name)
                .font(.title2.bold())
            Section("Address"){
                Text(item.addressString)
                if let postalCode = item.postalCode{
                    Text(postalCode)
                }
            }
            if let phoneNumber = item.phoneNumber{
                Section("Phone Number"){
                    Text(phoneNumber, format: .number)
                }
            }
            let isSelected = user?.map == item
            Button{
                user?.map = isSelected ? nil : item
            }label: {
                let name = isSelected ? "Cancel" : "Visit"
                Text(name)
                    .font(.headline)
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background(isSelected ? .red : .yellow)
                    .foregroundStyle(.white)
                    .cornerRadius(5)
            }
        }
    }
}
