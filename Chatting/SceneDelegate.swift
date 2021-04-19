//
//  SceneDelegate.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        guard let winScene = (scene as? UIWindowScene) else { return }
               
               let win = UIWindow(windowScene: winScene)
              
              let navigationController = UINavigationController()
              navigationController.navigationBar.tintColor = #colorLiteral(red: 0.05490196078, green: 0.2901960784, blue: 0.5254901961, alpha: 1)
        
              let moduleBuilder = ModuleBuilder()
              let router = Router(navigationController: navigationController, moduleBuilder: moduleBuilder)
               
              
              
               
               if AuthenticationService().token != nil {
                  AuthenticationService().auth { result in
                      switch result {
                      case .success(let user):
                          DispatchQueue.main.async {
                           router.chatListViewController(masterUser: user)
                          }
                      case .failure:
                          print("Login or password isn't correct")
                       DispatchQueue.main.async {
                           router.loginViewController()
                       }
                      }
                  }
                
               } else {
                   router.loginViewController()
               }
               
             // router.loginViewController()
               
               win.rootViewController = navigationController
               win.makeKeyAndVisible()
               
               window = win
    }


}

