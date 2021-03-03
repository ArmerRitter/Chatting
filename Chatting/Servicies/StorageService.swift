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
        get {
              let defaults = UserDefaults.standard
              
              if let savedMasterUser = defaults.object(forKey: "MASTER_USER") as? Data {
                  let decoder = JSONDecoder()
                  if let loadedMasterUser = try? decoder.decode(User.self, from: savedMasterUser) {
                    return loadedMasterUser
                  }
              }
              return nil
        }
        set {
            if let encoded =  try? JSONEncoder().encode(newValue) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "MASTER_USER")
            }
        }
    }
    
}

