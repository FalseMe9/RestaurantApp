//
//  UserSettingView.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 28/06/25.
//

import SwiftUI

struct UserSettingView: View {
    let user = MainData.shared.user?.data
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                Form{
                    Text("uid : \(user?.uid ?? "No ID")")
                    Text("email : \(user?.email ?? "No Email")")
                }
                Button("Log Out"){
                    try? AuthenticationManager.shared.signOut()
                    MainData.shared.showCoverPage = true
                }
                .tint(.red)
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle(user?.name ?? "No User")
        }
    }
}

#Preview {
    UserSettingView()
}
