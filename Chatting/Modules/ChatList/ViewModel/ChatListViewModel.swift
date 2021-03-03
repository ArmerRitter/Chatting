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
    
  //  var masterName: String? { get set }
  //  var masterUser: User { get set }
  //  var users: BehaviorRelay<[User]> { get }
    var currentDialogOfUser: User? { get set }
    var dialogs: BehaviorRelay<[Dialog]> { get set }
    var bag: DisposeBag { get }
    var service: ChattingService { get set }
    func logout()
    func tapOnAddNewDialog()
    func tapOnDialog(indexPath: IndexPath) 
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DialogTableViewCellViewModelType?
}



class ChatListViewModel: ChatListViewModelType {
    
   // var masterUser: User
    
    var router: RouterProtocol?
   // var users = BehaviorRelay<[User]>(value: [])
    var bag = DisposeBag()
    var dialogs = BehaviorRelay<[Dialog]>(value: [])
    var currentDialogOfUser: User?
    
    var service = ChattingService()
    
//    func saveUser(user: User) {
//        if let encoded =  try? JSONEncoder().encode(user) {
//            let defaults = UserDefaults.standard
//            defaults.set(encoded, forKey: "MASTER_USER")
//        }
//    }
    
    func logout() {
        AuthenticationService().logout()
        StorageManager.selfSender = nil
        router?.loginViewController()
    }
    
    func tapOnAddNewDialog() {
        router?.newDialogViewController(service: service)
    }
    
    func tapOnDialog(indexPath: IndexPath) {
      
        let dialog = dialogs.value[indexPath.row]
        dialog.unreadMessageCounter.accept(0)
        
        currentDialogOfUser = dialog.user
        
        router?.chatRoomViewController(dialog: dialog, service: service)
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DialogTableViewCellViewModelType? {
        
        let dialog = dialogs.value[indexPath.row]
        return DialogTableViewCellViewModel(dialog: dialog)
    }
    
    init(masterUser: User) {
     //   self.masterUser = masterUser
    //    self.masterName = masterUser.username
       // self.saveUser(user: masterUser)
        StorageManager.selfSender = masterUser
        service.connect(user: masterUser)
       
        
        service.inputMessages.subscribe(onNext: { [unowned self] message in
            guard let message = message.first else { return }
         
            let currentDialog = self.dialogs.value.filter { $0.user.username == message.sender.username }
            
            if currentDialog.isEmpty {
                
                let newDialog = Dialog(user: message.sender)
                newDialog.messages.accept([message])
                newDialog.unreadMessageCounter.accept(1)
                
                newDialog.messages.asObservable().subscribe(onNext: { [unowned self] message in
                    let dialogs = self.dialogs.value.filter { $0.user.username != newDialog.user.username }
                    self.dialogs.accept([newDialog] + dialogs)
                }).disposed(by: self.bag)
                
            } else {
                
                let messages = currentDialog[0].messages.value + [message]
                currentDialog[0].messages.accept(messages)
                
                if self.currentDialogOfUser?.username != message.sender.username {
                
                    let unreadCounter = currentDialog[0].unreadMessageCounter.value + 1
                    currentDialog[0].unreadMessageCounter.accept(unreadCounter)
                }
            }
           
            }).disposed(by: bag)
    }
}

