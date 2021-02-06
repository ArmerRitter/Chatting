//
//  MessageCellViewModel.swift
//  Chatting
//
//  Created by Yuriy Balabin on 29.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit

protocol MessageCellViewModelType {
    var messageText: String { get }
    var masterUser: User? { get }
    var messageSender: String { get }
    var messageSize: CGSize { get }
}


class MessageCellViewModel: MessageCellViewModelType {
    
    var message: Message
    
    var messageText: String {
        return message.text
    }
    
    var masterUser: User? {
        let defaults = UserDefaults.standard
        
        if let savedMasterUser = defaults.object(forKey: "MASTER_USER") as? Data {
            let decoder = JSONDecoder()
            if let loadedMasterUser = try? decoder.decode(User.self, from: savedMasterUser) {
              return loadedMasterUser
            }
        }
        return nil
    }
    
    var messageSender: String {
        return message.sender.username
    }
    
    var messageSize: CGSize {
        return message.text.messageBounds()
    }
    
    
    init(message: Message) {
        self.message = message
    }
    
}
