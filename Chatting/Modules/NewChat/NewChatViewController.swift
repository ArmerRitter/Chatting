//
//  NewChatViewController.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa


class NewChatViewController: UIViewController {
    
    var viewModel: NewChatViewModelType?
    var users = [User]()
    var filtredUsers = [User]()
    var searchIsActive = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "New Chat"
        return label
    }()
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.layer.borderWidth = 1
        bar.layer.borderColor = UIColor.white.cgColor
        return bar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupView()
        
       viewModel?.users.subscribe(onNext: { [unowned self] users in
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
       }).disposed(by: viewModel!.bag)
        
        loginButton.addTarget(self, action: #selector(tapOnLogin), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
    
    @objc func tapOnLogin() {
        
    }
    
    func setupView() {
        
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
//        searchController.searchBar.delegate = self
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
        

//        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension NewChatViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchIsActive = searchText == "" ? false : true
        searchBar.showsCancelButton = searchIsActive
        
        filtredUsers.removeAll()
        filtredUsers = users.filter { $0.username.contains(searchText) }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchIsActive = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let service = viewModel?.service else { return }
        
        if searchIsActive {
            let dialog = Dialog(user: filtredUsers[indexPath.row])
            viewModel?.router?.chatRoomViewController(dialog: dialog, service: service)
        } else {
            let dialog = Dialog(user: users[indexPath.row])
            viewModel?.router?.chatRoomViewController(dialog: dialog, service: service)
        }
        
        
        self.dismiss(animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchIsActive {
            return filtredUsers.count
        } else {
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        if searchIsActive {
            cell.textLabel?.text = filtredUsers[indexPath.row].username
            return cell
        } else {
            cell.textLabel?.text = users[indexPath.row].username
            return cell
        }
    
    }
    
}
