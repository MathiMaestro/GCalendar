//
//  PersistentManager.swift
//  calendar
//
//  Created by Mathiyalagan S on 21/11/22.
//

import Foundation

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    static func updateToken(with tokenDetail: TokenDetail?) {
        do {
            let encoder = JSONEncoder()
            let encodedToken = try encoder.encode(tokenDetail)
            defaults.set(encodedToken, forKey: "tokenDetail")
        } catch {
            print(error)
        }
    }
    
    static func getToken() -> TokenDetail? {
        guard let decodedToken = defaults.object(forKey: "tokenDetail") as? Data else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(TokenDetail.self, from: decodedToken)
        } catch {
            return nil
        }
    }
    
    static func removeToken() {
        defaults.removeObject(forKey: "tokenDetail")
    }
}
