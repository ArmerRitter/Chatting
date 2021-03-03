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
    var messageSender: String { get }
    var messageSize: CGSize { get }
    var messageTime: String { get }
}


class MessageCellViewModel: MessageCellViewModelType {
    
    var message: Message
    
    var messageText: String {
        return message.text.trimmingCharacters(in: .whitespaces)
    }
    
    var messageSender: String {
        return message.sender.username
    }
    
    var messageSize: CGSize {
        let text = message.text.trimmingCharacters(in: .whitespaces)
        return text.messageBounds()
    }
    
    var messageTime: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        
        return dateFormater.string(from: message.date)
    }
    
    init(message: Message) {
        self.message = message
    }
    
}
