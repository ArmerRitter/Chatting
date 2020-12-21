//
//  ChatRoomViewController.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay


class ChatRoomViewController: UITableViewController {
    
    var viewModel: ChatRoomViewModelType?
   // let service = ChattingService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      //  service.disconnect()
      //  print("disappeaar")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = viewModel?.user else { return }
      //  service.connect(user: user)
        
        setupView()
    }
    
    func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(tapOnBack))
        title = viewModel?.user?.username
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapOnAdd))
    }
    
    @objc func tapOnAdd() {
        guard let user = viewModel?.user else { return }
        let mess = Message(sender: "Q7", reciever: user, text: "hallo 7")
      //  service.disconnect()
    
        viewModel?.service?.send(mess) { result in
            
        }
        
    }
    
    @objc func tapOnBack() {
        guard let chatListViewController = navigationController?.previosViewController as? ChatListViewController, let user = viewModel?.user else {
            return
        }
        
        chatListViewController.viewModel?.users.accept([user])
        navigationController?.popViewController(animated: true)
    }
    
   
}

