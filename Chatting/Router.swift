//
//  Router.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit


enum Route {
    case signIn
    case chatList
}

protocol RouterProtocol {
    func loginViewController()
    func chatListViewController(masterUser: User)
    func signupViewController()
    func newChatViewController(service: ChattingServiceProtocol)
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
    
    func newChatViewController(service: ChattingServiceProtocol) {
        if let navigationController = navigationController {
            guard let newChatViewController = moduleBuilder?.createNewChatModule(router: self, service: service) else { return }
            navigationController.present(newChatViewController, animated: true)
        }
    }
    
    func chatRoomViewController(dialog: Dialog, service: ChattingServiceProtocol) {
        if let navigationController = navigationController {
            guard let chatRoomViewController = moduleBuilder?.createChatRoomModule(router: self, service: service) as? ChatRoomViewController else { return }
            
//            if dialog.unreadMessages.value.count > 0 {
//                dialog.messages =
//            }
            
            chatRoomViewController.viewModel?.dialog = dialog
            
            navigationController.pushViewController(chatRoomViewController, animated: true)
            
            guard let vc = navigationController.viewControllers.first as? ChatListViewController else { return }
            var dialogs = vc.viewModel!.dialogs.value
         
            if dialogs.filter { $0.user.username == dialog.user.username }.count == 0 {
                dialogs.append(dialog)
                vc.viewModel?.dialogs.accept(dialogs)
            }
        }
        
        
    }
    
    func route(to routeID: Route) {
        
        
        switch routeID {
        case .chatList:
            let chatListVC = UINavigationController(rootViewController: ChatListViewController())
            chatListVC.modalPresentationStyle = .fullScreen
            viewController?.present(chatListVC, animated: true)
        case .signIn:
            let signInVC = SignupViewController()
            viewController?.present(signInVC, animated: true)
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
