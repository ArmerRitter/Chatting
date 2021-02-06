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
    var dialogs = [Dialog]()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.currentUser = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
   //     title = ""
   //     navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chats"
        
//       viewModel?.dialogs.subscribe(onNext: { [unowned self] dialog in
//           self.dialogs = dialog
//           DispatchQueue.main.async {
//               self.tableView.reloadData()
//           }
//        print("dialogSubVC")
//       }).disposed(by: viewModel!.bag)
        tableView.dataSource = nil
        
        //let nib = UINib(nibName: "DialogTableViewCell", bundle: nil)
        
        tableView.register(DialogTableViewCell.self, forCellReuseIdentifier: "dialogCellidentifyer")
        
        viewModel?.dialogs.asObservable().bind(to: tableView.rx.items(cellIdentifier: "dialogCellidentifyer", cellType: DialogTableViewCell.self)) { index, item, cell in
            
       //     DispatchQueue.main.async {
                let viewModelCell = DialogTableViewCellViewModel(dialog: item)
                cell.configure(viewModel: viewModelCell)
        //    }

        }.disposed(by: viewModel!.bag)
        
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
       // tableView.reloadData()
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
    
/*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count //users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = dialogs[indexPath.row].user.username
        
        return cell
    }  */
}

