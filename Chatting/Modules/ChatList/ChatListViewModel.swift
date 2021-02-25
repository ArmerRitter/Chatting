//
//  ChatListViewModel.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Starscream

protocol ChatListViewModelType {
    
    var masterName: String? { get set }
    var masterUser: User { get set }
    var users: BehaviorRelay<[User]> { get }
    var currentUser: User? { get set }
    var dialogs: BehaviorRelay<[Dialog]> { get set }
    var bag: DisposeBag { get }
    var service: ChattingService { get set }
    func logout()
    func tapOnAdd()
    func tapOnDialog(indexPath: IndexPath) 
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DialogTableViewCellViewModelType?
}



class ChatListViewModel: ChatListViewModelType {
    
    var masterName: String? {
        get {
            return UserDefaults.standard.string(forKey: "MASTER_NAME")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "MASTER_NAME")
        }
    }
    
    var masterUser: User
    
    var router: RouterProtocol?
    var users = BehaviorRelay<[User]>(value: [])
    var bag = DisposeBag()
    var dialogs = BehaviorRelay<[Dialog]>(value: [])
    var currentUser: User?
    
    var service = ChattingService()
    
    func saveUser(user: User) {
        if let encoded =  try? JSONEncoder().encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "MASTER_USER")
        }
    }
    
    func logout() {
        AuthenticationService().logout()
        masterName = nil
        UserDefaults.standard.set(nil, forKey: "MASTER_USER")
        router?.loginViewController()
    }
    
    func tapOnAdd() {
        router?.newChatViewController(service: service)
        
    }
    
    func tapOnDialog(indexPath: IndexPath) {
       // dialogs.value[indexPath.row].unreadMessageCounter.accept(0)
        let dialog = dialogs.value[indexPath.row]
        dialog.unreadMessageCounter.accept(0)
        
        currentUser = dialog.user
        
        router?.chatRoomViewController(dialog: dialog, service: service)
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DialogTableViewCellViewModelType? {
        
        let dialog = dialogs.value[indexPath.row]
        return DialogTableViewCellViewModel(dialog: dialog)
    }
    
    init(masterUser: User) {
        self.masterUser = masterUser
        self.masterName = masterUser.username
        self.saveUser(user: masterUser)
        service.connect(user: masterUser)
        print(masterUser.username)
        
        service.inputMessages.subscribe(onNext: { [unowned self] message in
            guard let message = message.first else { return }
         
            let currentDialog = self.dialogs.value.filter { $0.user.username == message.sender.username }
            
            if currentDialog.isEmpty {
                
                let newDialog = Dialog(user: message.sender)
                newDialog.unreadMessages.accept([message])
                newDialog.unreadMessageCounter.accept(1)
                
                let dialogs = self.dialogs.value + [newDialog]
                self.dialogs.accept(dialogs)
            } else {
                
                let messages = currentDialog[0].unreadMessages.value + [message]
                currentDialog[0].unreadMessages.accept(messages)
                print(currentDialog[0].unreadMessageCounter.value)
                
                if self.currentUser?.username != message.sender.username {
                
                    let unreadCounter = currentDialog[0].unreadMessageCounter.value + 1
                    currentDialog[0].unreadMessageCounter.accept(unreadCounter)
                
                    print(currentDialog[0].unreadMessageCounter.value)
                }
            }
           
            }).disposed(by: bag)
    }
}

