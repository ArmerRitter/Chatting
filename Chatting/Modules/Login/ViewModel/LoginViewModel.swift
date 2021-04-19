//
//  LoginViewModel.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation


protocol LoginViewModelType {
    var router: RouterProtocol? { get }
    func login(username: String?, password: String?)
}

class LoginViewModel: LoginViewModelType {
    
   var router: RouterProtocol?
    
    func auth() {
        AuthenticationService().auth { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.router?.chatListViewController(masterUser: user)
                }
            case .failure:
                print("failure")
            }
        }
    }
    
   func login(username: String?, password: String?)  {
    
        guard let username = username, let password = password else {
            return
        }
        
        AuthenticationService().login(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                print("success")
                DispatchQueue.main.async {
                    self?.router?.chatListViewController(masterUser: user)
                }
            case .failure:
                print("failure")

            }
        }
  
    }
    
}
