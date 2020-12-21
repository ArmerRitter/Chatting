//
//  ChatRoomViewModel.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

protocol ChatRoomViewModelType {
    var user: User? { get set }
    var service: ChattingService? { get set }
}

class ChatRoomViewModel: ChatRoomViewModelType {
    
    var router: RouterProtocol?
    var service: ChattingService?
    
    var user: User?
    
}
