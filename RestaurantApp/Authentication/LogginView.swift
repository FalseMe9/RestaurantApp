//
//  LogginView.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 28/06/25.
//

import SwiftUI
import GoogleSignInSwift
import FirebaseAuth

@MainActor@Observable
final class SignInViewModel{
    func signInWithGoogle() async throws
    -> AuthDataResultModel{
        let helper = SignInGoogleHelper()
        let token = try await helper.signIn()
        return try await AuthenticationManager.shared.signInWithGoogle(token: token)
    }
    static let shared = SignInViewModel()
}
struct LogginView: View {
    @State var model = SignInViewModel.shared
    @State var main = MainData.shared
    var body: some View {
        VStack {
            Spacer()
            Image("RestaurantLogo")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Get-Resto")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            
            GoogleSignInButton(scheme: .dark, style: .wide, state: .normal){
                    Task{
                        do{
                            let user = try await model.signInWithGoogle()
                            main.user = UserData(user: user)
                            await main.user?.load()
                            main.showCoverPage = false
                        }catch{
                            print("error: \(error)")
                        }
                    }
                }
                .padding()
            Spacer()
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .background(Color.darkGreen)
    }
}

#Preview {
    LogginView()
}
