//
//  MessageCellViewModel.swift
//  Chatting
//
//  Created by Yuriy Balabin on 29.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

protocol MessageCellViewModelType {
    var messageText: String { get }
}


class MessageCellViewModel: MessageCellViewModelType {
    
    var message: Message
    
    var messageText: String {
        return message.text
    }
    
    var messageSender: String {
        return message.reciever.username
    }
    
    init(message: Message) {
        self.message = message
    }
    
}
