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
    var messages: [Message] { get set }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> MessageCellViewModelType?
    func numberOfrows() -> Int
    func send(text: String)
}

class ChatRoomViewModel: ChatRoomViewModelType {
    
    var router: RouterProtocol?
    var service: ChattingServiceProtocol
    var messages = [Message]()
    
    var dialog: Dialog?
    
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> MessageCellViewModelType? {
        
        let message = dialog!.messages[indexPath.row]
        return MessageCellViewModel(message: message)
    }
    
    func numberOfrows() -> Int {
        return dialog?.messages.count ?? 0
    }
    
    func loadMaser() -> User? {
        let defaults = UserDefaults.standard
        
        if let savedMasterUser = defaults.object(forKey: "MASTER_USER") as? Data {
            let decoder = JSONDecoder()
            if let loadedMasterUser = try? decoder.decode(User.self, from: savedMasterUser) {
              return loadedMasterUser
            }
        }
        return nil
    }
    
    func send(text: String) {
        
        guard let reciever = dialog?.user, let sender = loadMaser() else { print("master"); return }
        
        let message = Message(sender: sender, reciever: reciever, text: text, date: Date())
     
        dialog?.messages.append(message)
   
        service.send(message, completion: { result in
            
        })
    }
    
    init(service: ChattingServiceProtocol) {
        self.service = service

    }
}
