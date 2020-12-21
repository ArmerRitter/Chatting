//
//  Token.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation


final class Token: Codable {
  var token: String
  var user: User

  init(token: String, user: User) {
    self.token = token
    self.user = user
  }
}
