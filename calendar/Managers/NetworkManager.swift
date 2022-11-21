//
//  NetworkManager.swift
//  calendar
//
//  Created by Mathiyalagan S on 21/11/22.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func makeRequest(url: URL, httpMethod: HttpMethod, token: String? = nil, completed: @escaping (Result<Data,CalendarError>) -> Void) {
        let urlRequest = CalendarNetworkUtils.createUrlRequest(for: url, httpMethod: httpMethod, token: token)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                let nsError = error as NSError
                
                switch nsError.code {
                    case NSURLErrorNotConnectedToInternet, NSURLErrorInternationalRoamingOff, NSURLErrorDataNotAllowed:
                        completed(.failure(.networkConnection))
                    default:
                        completed(.failure(.unknown))
                }
            }
            
            guard let response = response as? HTTPURLResponse else {
                completed(.failure(.invalidResponse))
                return
            }
            
            switch response.statusCode {
            case 200, 204:
                guard let data = data else {
                    completed(.failure(.invalidData))
                    return
                }
                completed(.success(data))
            default:
                completed(.failure(.unknown))
            }

        }
        task.resume()
    }
}

