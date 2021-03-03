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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.currentDialogOfUser = nil
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBinding()
    }
    
    func setupBinding() {
        
        viewModel?.dialogs.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "dialogCellidentifyer", cellType: DialogTableViewCell.self)) { index, item, cell in
                
                let viewModelCell = DialogTableViewCellViewModel(dialog: item)
                cell.configure(viewModel: viewModelCell)
                
        }.disposed(by: viewModel!.bag)
    }
    
    func setupView() {
        
        title = "Chats"
        
        tableView.register(DialogTableViewCell.self, forCellReuseIdentifier: "dialogCellidentifyer")
        tableView.dataSource = nil
        tableView.tableFooterView = UIView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(tapOnLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapOnAddNewDialog))
    }

    @objc func tapOnAddNewDialog() {
        viewModel?.tapOnAddNewDialog()
    }
    
    @objc func tapOnLogout() {
        viewModel?.logout()
    }
} 

extension ChatListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.tapOnDialog(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

