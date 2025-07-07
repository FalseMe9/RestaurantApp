//
//  ContentView.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 27/06/25.
//
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import SwiftUI
import GoogleSignInSwift



struct ContentView: View {
    @State private var main = MainData.shared
    var body: some View{
        ZStack{
            if let user = main.user{
                MainView(user: user)
            }
        }
        .onAppear{
            Task{
                let user = try AuthenticationManager.shared.getCurrentUser()
                main.user = UserData(user: user)
                await main.user?.load()
                main.showCoverPage = main.user == nil
            }
        }
        .fullScreenCover(isPresented: $main.showCoverPage){
            LogginView()
        }
    }
}

#Preview {
    ContentView()
}
