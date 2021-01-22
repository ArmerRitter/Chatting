//
//  Dialog.swift
//  Chatting
//
//  Created by Yuriy Balabin on 17.01.2021.
//  Copyright © 2021 None. All rights reserved.
//

import Foundation
import RxRelay


class Dialog {
    
    var user: User
    var messages: [Message]
    var unreadMessages = BehaviorRelay<[Message]>(value: [])
    
    init(user: User) {
        self.user = user
        self.messages = []
    }
    
}
