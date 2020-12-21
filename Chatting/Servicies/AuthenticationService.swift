//
//  AuthenticationService.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation


enum RequestResult<ResourceType> {
    case success(ResourceType)
    case failure
}

class AuthenticationService {
    
    static let defaultsKey = "USER_TOKEN"
    let defaults = UserDefaults.standard

    var token: String? {
      get {
        return defaults.string(forKey: AuthenticationService.defaultsKey)
      }
      set {
        defaults.set(newValue, forKey: AuthenticationService.defaultsKey)
      }
    }
    
    func auth(completion: @escaping (RequestResult<User>) -> Void) {
        
        guard let token = token else { print("return"); return }
        
        let path = "http://localhost:8080/api/users/me"
        guard let url = URL(string: path) else {
          fatalError()
        }
        
        var authRequest = URLRequest(url: url)
        
        authRequest.httpMethod = "GET"
        authRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: authRequest) { data, response, _ in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure)
                    return
                }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                completion(.success(user))
            } catch {
                completion(.failure)
            }
        }
        dataTask.resume()
    }
    
    func logout() {
        self.token = nil
    }
    
    func login(username: String, password: String, completion: @escaping (RequestResult<User>) -> Void) {
        
        let path = "http://localhost:8080/api/users/login"
        guard let url = URL(string: path) else {
          fatalError()
        }
        
        guard let loginString = "\(username):\(password)"
            .data(using: .utf8)?
            .base64EncodedString()
            else {
                fatalError()
          }
        
        var loginRequest = URLRequest(url: url)
        
        loginRequest.addValue("Basic \(loginString)",forHTTPHeaderField: "Authorization")
        loginRequest.httpMethod = "POST"
    
        let dataTask = URLSession.shared.dataTask(with: loginRequest) { data, response, _ in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                completion(.failure)
      
                return
            }
            
            do {
                let token = try JSONDecoder().decode(Token.self, from: jsonData)
                self.token = token.token
                completion(.success(token.user))
     
            } catch {
                completion(.failure)
            }
            
        }
        
        dataTask.resume()
    }
    
    
}
