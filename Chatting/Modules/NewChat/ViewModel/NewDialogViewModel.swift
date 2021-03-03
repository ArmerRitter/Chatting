//
//  NewChatViewModel.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol NewDialogViewModelType {
    var users: BehaviorRelay<[User]> { get }
    var bag: DisposeBag { get }
    func tapOnUser(with dialog: Dialog)
}


class NewDialogViewModel: NewDialogViewModelType {
    
    var router: RouterProtocol?
    var service: ChattingServiceProtocol
    
    var users = BehaviorRelay<[User]>(value: [])
    var bag = DisposeBag()
    
    func tapOnUser(with dialog: Dialog) {
        router?.chatRoomViewController(dialog: dialog, service: service)
    }
    
    func getAllUsers() {
        
        service.getAllUsers { [weak self] result in
            switch result {
            case .success(let users):
                let selfUser = StorageManager.selfSender
                let sortedUsers = users.sorted { $0.username < $1.username }
                                       .filter { $0.username != selfUser?.username }
                self?.users.accept(sortedUsers)
            case .failure:
                print("failure")
            }
        }
    }
    
    init(service: ChattingServiceProtocol) {
        self.service = service
        getAllUsers()
    }
    
}

