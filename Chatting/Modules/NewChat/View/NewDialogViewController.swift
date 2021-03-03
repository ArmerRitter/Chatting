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


class NewDialogViewController: UIViewController {
    
    var viewModel: NewDialogViewModelType?
    var users = [User]()
    var filtredUsers = [User]()
    var searchIsActive = false
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "New Chat"
        return label
    }()
    
    private let userSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.layer.borderWidth = 1
        bar.layer.borderColor = UIColor.white.cgColor
        return bar
    }()
    
    private let usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupView()
       setupConstraints()
        
       viewModel?.users.subscribe(onNext: { [unowned self] users in
            self.users = users
            DispatchQueue.main.async {
                self.usersTableView.reloadData()
            }
       }).disposed(by: viewModel!.bag)
        
       
    }
    
    func setupView() {
        
        view.backgroundColor = .white
        
        usersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        usersTableView.tableFooterView = UIView()
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        userSearchBar.delegate = self
    }
    
    func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(userSearchBar)
        view.addSubview(usersTableView)
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        userSearchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        userSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        userSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        
        usersTableView.topAnchor.constraint(equalTo: userSearchBar.bottomAnchor).isActive = true
        usersTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        usersTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension NewDialogViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchIsActive = searchText == "" ? false : true
        searchBar.showsCancelButton = searchIsActive
        
        filtredUsers.removeAll()
        filtredUsers = users.filter { $0.username.contains(searchText) }
        
        usersTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchIsActive = false
        usersTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
}

extension NewDialogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if searchIsActive {
            let dialog = Dialog(user: filtredUsers[indexPath.row])
            viewModel?.tapOnUser(with: dialog)
        } else {
            let dialog = Dialog(user: users[indexPath.row])
            viewModel?.tapOnUser(with: dialog)
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
