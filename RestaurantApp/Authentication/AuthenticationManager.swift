//
//  AuthenticationManager.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 27/06/25.
//

import Foundation
import FirebaseAuth
struct AuthDataResultModel:Codable{
    let uid : String
    let email : String?
    let name : String?
    init(user : User){
        uid = user.uid
        email = user.email
        name = user.displayName
    }
}
@MainActor@Observable
class AuthenticationManager{
    func getCurrentUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
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
    func signOut()throws{
        try Auth.auth().signOut()
    }
    static let shared = AuthenticationManager()
}
