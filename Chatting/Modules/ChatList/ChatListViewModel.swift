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
    var bag: DisposeBag { get }
    func logout()
    func tapOnAdd()
    func cellViewModel(forIndexPath indexPath: IndexPath) -> UserCellViewModelType?
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
    
    var service = ChattingService()
    
    func logout() {
        AuthenticationService().logout()
        router?.loginViewController()
    }
    
    func tapOnAdd() {
        router?.newChatViewController(service: service)
        
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> UserCellViewModelType? {
        
        return UserCellViewModel()
    }
    
    init(masterUser: User) {
        self.masterUser = masterUser
        service.connect(user: masterUser)
        print(masterUser.username)
    }
}

