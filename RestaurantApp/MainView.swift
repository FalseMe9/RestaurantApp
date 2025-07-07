//
//  MainView.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 28/06/25.
//

import SwiftUI

struct MainView: View {
    @Bindable var user : UserData
    var body: some View{
        TabView{
            Tab("Restaurant", systemImage: "fork.knife.circle"){
                RestaurantView(user: user)
            }
            Tab("Contact", systemImage: "person.3"){
                ContactView()
            }
            Tab("Setting", systemImage: "gear"){
                UserSettingView()
            }
        }
        .navigationTitle(user.data.name ?? "No User Logged In")
    }

}
