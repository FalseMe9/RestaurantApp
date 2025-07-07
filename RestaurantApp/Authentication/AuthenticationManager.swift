//
//  AuthenticationManager.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 27/06/25.
//

import Foundation
import FirebaseAuth
struct AuthDataResultModel{
    let uid : String
    let email : String?
    init(user : User){
        uid = user.uid
        email = user.email
    }
}
@MainActor@Observable
class AuthenticationManager{
    func signInWithGoogle(token : GoogleSignInResultModel) async throws
    -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: token.idToken, accessToken: token.accessToken)
        return try await signInWith(credential)
    }
    func signInWith(_ credential : AuthCredential) async throws
    -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
