//
//  ModuleBuilder.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit


class ModuleBuilder {
    
    func createLoginModule(router: RouterProtocol) -> UIViewController {
        let view = LoginViewController()
        let viewModel = LoginViewModel()
        
        viewModel.router = router
        view.viewModel = viewModel
        return view
    }
    
    func createSignupModule(router: RouterProtocol) -> UIViewController {
        let view = SignupViewController()
        let viewModel = SignupViewModel()
        
        viewModel.router = router
        view.viewModel = viewModel
        return view
    }
    
    func createChatListModule(masterUser: User, router: RouterProtocol) -> UIViewController {
        let view = ChatListViewController()
        let viewModel = ChatListViewModel(masterUser: masterUser)
        
        viewModel.router = router
        view.viewModel = viewModel
        return view
    }
    
    func createNewDialogModule(router: RouterProtocol, service: ChattingServiceProtocol) -> UIViewController {
        let view = NewDialogViewController()
        let viewModel = NewDialogViewModel(service: service)
        
        viewModel.router = router
        view.viewModel = viewModel
        return view
    }
    
    func createChatRoomModule(router: RouterProtocol, service: ChattingServiceProtocol) -> UIViewController {
        let view = ChatRoomViewController()
        let viewModel = ChatRoomViewModel(service: service)
        
        viewModel.router = router
        view.viewModel = viewModel
        return view
    }
    
}

