//
//  SignupViewModel.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation


protocol SignupViewModelType {
    func signup(username: String?, password: String?, confirmPassword: String?)
}

class SignupViewModel: SignupViewModelType {
    
    var router: RouterProtocol?
    
    
    func signup(username: String?, password: String?, confirmPassword: String?) {
        
        guard let username = username, let password = password, let confirmPassword = confirmPassword else {
            return
        }
        
        AuthenticationService().signup(username: username, password: password, confirmPassword: confirmPassword) { [weak self] result in
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
}
