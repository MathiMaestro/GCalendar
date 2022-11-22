//
//  UserManager.swift
//  calendar
//
//  Created by Mathiyalagan S on 20/11/22.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

class UserManager {
    
    static let shared       = UserManager()
    var isFirstTime: Bool   = true
    
    var spotLightEventId : String?
    
    var tokenDetail : TokenDetail? {
        get {
            return PersistenceManager.getToken()
        }
        set {
            if let newValue {
                PersistenceManager.updateToken(with: newValue)
            }
            else {
                PersistenceManager.removeToken()
            }
        }
    }
    
    func checIsSessionValid(completed: @escaping (Result<Bool,CalendarError>) -> ()){
        guard let tokenDetail else {
            completed(.failure(.sessionExpired))
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: tokenDetail.idToken, accessToken: tokenDetail.accessToken)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
              let _ = error as NSError
                completed(.failure(.sessionExpired))
            } else {
                completed(.success(true))
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        tokenDetail = nil
    }
}

struct TokenDetail : Codable {
    var idToken: String
    var accessToken: String
}
