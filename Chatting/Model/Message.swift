//
//  Message.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

//enum MessageType: String, Codable {
//    case handshake
//    case message
//}
var shakes = [HandShake]()

enum MessageError: Error {
    case unknownValue
}

enum MessageContent {
    case handshake(HandShake)
    case message(Message)
}

struct HandShake: Codable {
    let id: UUID
}

struct Message: Codable {
    var sender: String
    var reciever: User
    var text: String
}

extension MessageContent: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {

        if let handshake = try? decoder.singleValueContainer().decode(HandShake.self) {
            self = .handshake(handshake)
            return
        }
        
        if let message = try? decoder.singleValueContainer().decode(Message.self) {
            self = .message(message)
            return
        }
        
        throw MessageError.unknownValue
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
}
