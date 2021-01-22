//
//  User.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation


final class User: Codable {
    
    var id: UUID?
    var username: String
}

final class CreateUser: Codable {
    var username: String
    var password: String
    var confirmPassword: String
    
    init(username: String, password: String, confirmPassword: String) {
      self.username = username
      self.password = password
      self.confirmPassword = confirmPassword
    }
}
