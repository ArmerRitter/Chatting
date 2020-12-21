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

protocol NewChatViewModelType {
    var router: RouterProtocol? { get }
    var service: ChattingService { get set }
    var users: BehaviorRelay<[User]> { get }
    var bag: DisposeBag { get }
    func numberOfCount() -> Int
}


class NewChatViewModel: NewChatViewModelType {
    
    var router: RouterProtocol?
    var service: ChattingService
    var users = BehaviorRelay<[User]>(value: [])
    var bag = DisposeBag()
    
    func numberOfCount() -> Int {
        return 3
    }
    
    func getAllUsers() {
        
     //   guard let service = service else { return }
        
        service.getAllUsers { [weak self] result in
            switch result {
            case .success(let users):
                let sortedUsers = users.sorted { $0.username < $1.username }
                self?.users.accept(sortedUsers)
         //      users.forEach { print($0.username) }
            case .failure:
                print("failure")
            }
        }
    }
    
    init(service: ChattingService) {
        self.service = service
        getAllUsers()
    }
    
}

