//
//  ChatListViewController.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit

class ChatListViewController: UITableViewController {

    var viewModel: ChatListViewModelType?
    var users = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  title = "Chats"
   //     navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
   //     title = ""
   //     navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chats"
        
        viewModel?.users.subscribe(onNext: { [unowned self] users in
            self.users += users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).disposed(by: viewModel!.bag)
        
        setupView()
    }
    
    func setupView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(tapOnLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapOnAdd))
    }

    @objc func tapOnAdd() {
        viewModel?.tapOnAdd()
    }
    
    @objc func tapOnLogout() {
        viewModel?.logout()
    }
}

extension ChatListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = users[indexPath.row].username
        
        return cell
    }
}

