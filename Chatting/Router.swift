//
//  Router.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit


protocol RouterProtocol {
    func loginViewController()
    func chatListViewController(masterUser: User)
    func signupViewController()
    func newDialogViewController(service: ChattingServiceProtocol)
    func chatRoomViewController(dialog: Dialog, service: ChattingServiceProtocol)
    var navigationController: UINavigationController? { get }
}

class Router: RouterProtocol {
    
    weak var viewController: UIViewController?
    var navigationController: UINavigationController?
    var moduleBuilder: ModuleBuilder?
    
    func loginViewController() {
        if let navigationController = navigationController {
            guard let loginViewController = moduleBuilder?.createLoginModule(router: self) else { return }
            navigationController.viewControllers = [loginViewController]
           // navigationController.pushViewController(loginViewController, animated: true)
        }
    }
    
    func signupViewController() {
        if let navigationController = navigationController {
            guard let signupViewController = moduleBuilder?.createSignupModule(router: self) else { return }
            navigationController.present(signupViewController, animated: true)
        }
    }
    
    func chatListViewController(masterUser: User) {
        if let navigationController = navigationController {
            guard let chatListViewController = moduleBuilder?.createChatListModule(masterUser: masterUser, router: self) else { return }
            navigationController.pushViewController(chatListViewController, animated: true)
            navigationController.dismiss(animated: true)
        }
    }
    
    func newDialogViewController(service: ChattingServiceProtocol) {
        if let navigationController = navigationController {
            guard let newDialogViewController = moduleBuilder?.createNewDialogModule(router: self, service: service) else { return }
            navigationController.present(newDialogViewController, animated: true)
        }
    }
    
    func chatRoomViewController(dialog: Dialog, service: ChattingServiceProtocol) {
        if let navigationController = navigationController {
            guard let chatRoomViewController = moduleBuilder?.createChatRoomModule(router: self, service: service) as? ChatRoomViewController else { return }
            
            chatRoomViewController.viewModel?.dialog = dialog
            navigationController.pushViewController(chatRoomViewController, animated: true)
            
            guard let chatListViewController = navigationController.viewControllers.first as? ChatListViewController else { return }
            
            let dialogs = chatListViewController.viewModel!.dialogs.value
            
            if !dialogs.contains(dialog) {
                
                dialog.messages.asObservable().subscribe(onNext: { message in
                    let anotherDialogs = dialogs.filter { $0.user.username != dialog.user.username }
                    chatListViewController.viewModel!.dialogs.accept([dialog] + anotherDialogs)
                }).disposed(by: chatListViewController.viewModel!.bag)
               
            }
        }
        
        
    }
    
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilder) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    
}

extension UINavigationController {
    var previosViewController: UIViewController? {
        viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
}
