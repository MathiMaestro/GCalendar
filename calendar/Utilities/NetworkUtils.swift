//
//  NetworkUtils.swift
//  calendar
//
//  Created by Mathiyalagan S on 21/11/22.
//

import Foundation

enum HttpMethod : String {
    case get    = "GET"
    case post   = "POST"
    case delete = "DELETE"
}

enum CalendarNetworkUtils {
    
    static let decoder : JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static func createUrlRequest(for url: URL, httpMethod: HttpMethod, token: String? = nil, body: Data? = nil) -> URLRequest {
        var urlRequest              = URLRequest(url: url)
        urlRequest.httpMethod       = httpMethod.rawValue
        urlRequest.timeoutInterval  = 30
        
        if let token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
    
    static func getData(from bodyJson: [[String : Any]]) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: bodyJson)
        } catch {
            return nil
        }
    }
}
