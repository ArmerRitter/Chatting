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
        router?.chatRoomViewController(dialog: dialogs.value[indexPath.row], service: service)
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
        
//        users.subscribe(onNext: { [unowned self] users in
//            guard let user = users.first else { return }
//            let dialog = Dialog(user: user)
//            self.dialogs.accept([dialog])
//            print("userSub")
//        }).disposed(by: bag)
        
        service.inputMessages.subscribe(onNext: { [unowned self] message in
            guard let message = message.first else { return }
            
            let currentDialog = self.dialogs.value.filter { $0.user.username == message.sender.username }
            if currentDialog.isEmpty {
                let newDialog = Dialog(user: message.sender)
                newDialog.unreadMessages.accept([message])
                
                let dialogs = self.dialogs.value + [newDialog]
                self.dialogs.accept(dialogs)
            } else {
                let messages = currentDialog[0].unreadMessages.value + [message]
                currentDialog[0].unreadMessages.accept(messages)
                print(currentDialog[0].unreadMessages.value.count)
            }
           
            }).disposed(by: bag)
    }
}

