//
//  ChatRoomViewModel.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol ChatRoomViewModelType {
    
    var dialog: Dialog? { get set }
    var service: ChattingServiceProtocol { get set }
   // var messages: [Message] { get set }
    var bag: DisposeBag { get }
   // var cellHeights: [IndexPath : CGFloat] { get set }
    func cellViewModel(forIndexPath indexPath: IndexPath) -> MessageCellViewModelType
    func numberOfrows() -> Int
    func send(text: String)
}

class ChatRoomViewModel: ChatRoomViewModelType {
    
    var router: RouterProtocol?
    var service: ChattingServiceProtocol
    var bag = DisposeBag()
    
    var dialog: Dialog?
    
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> MessageCellViewModelType {
        
        var message = dialog!.unreadMessages.value[indexPath.row]
        message.status = .read
       
        return MessageCellViewModel(message: message)
    }
    
    func numberOfrows() -> Int {
        return dialog?.unreadMessages.value.count ?? 0
    }
    
    func send(text: String) {
        
        guard let reciever = dialog?.user, let sender = StorageManager.selfSender else { return }
        
        let message = Message(sender: sender, reciever: reciever, text: text, date: Date(), status: .read)
     
        let messages = dialog!.unreadMessages.value + [message]
        dialog?.unreadMessages.accept(messages)
      
        
        service.send(message, completion: { result in
            
        })
        
    }
    
    init(service: ChattingServiceProtocol) {
        self.service = service
    }
}
