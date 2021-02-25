//
//  StorageService.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import CoreData


class StorageManager {
    
  let shared = StorageManager()
    
  static var selfSender: User? {
          let defaults = UserDefaults.standard
          
          if let savedMasterUser = defaults.object(forKey: "MASTER_USER") as? Data {
              let decoder = JSONDecoder()
              if let loadedMasterUser = try? decoder.decode(User.self, from: savedMasterUser) {
                return loadedMasterUser
              }
          }
          return nil
      }
}

