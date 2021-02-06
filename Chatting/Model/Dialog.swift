//
//  Dialog.swift
//  Chatting
//
//  Created by Yuriy Balabin on 17.01.2021.
//  Copyright © 2021 None. All rights reserved.
//

import Foundation
import RxRelay


class Dialog: NSObject {
   
    var user: User
    var messages: [Message]
    var unreadMessages = BehaviorRelay<[Message]>(value: [])
    var unreadMessageCounter = BehaviorRelay<Int>(value: 0)
    
    init(user: User) {
        self.user = user
        self.messages = []
    }
    
}
