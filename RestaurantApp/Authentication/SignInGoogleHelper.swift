//
//  SignInGoogleHelper.swift
//  Restaurant
//
//  Created by Billie Hartanto on 13/05/25.
//

import Foundation
import GoogleSignIn
struct GoogleSignInResultModel{
    let idToken : String
    let accessToken : String
}

final class SignInGoogleHelper{
    
    @MainActor
    func signIn() async throws  -> GoogleSignInResultModel{
        guard let topVC = Uttilities.shared.topViewController() else{
            throw URLError(.badServerResponse)
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken : String = gidSignInResult.user.idToken?.tokenString else{
            throw URLError(.badServerResponse)
        }
        let accessToken : String = gidSignInResult.user.accessToken.tokenString
        let token = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        return token
    }
}
