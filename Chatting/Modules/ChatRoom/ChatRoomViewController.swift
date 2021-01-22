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


class ChatRoomViewController: UIViewController {
    
    var viewModel: ChatRoomViewModelType?
   
    var messageTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var messageTextField: MessageTextField = {
        let textfiled = MessageTextField()
        textfiled.translatesAutoresizingMaskIntoConstraints = false
        textfiled.layer.cornerRadius = 17
        textfiled.layer.masksToBounds = true
        textfiled.layer.borderColor = UIColor.lightGray.cgColor
        textfiled.layer.borderWidth = 1
        textfiled.placeholder = "Type message"
        textfiled.backgroundColor = .white
        return textfiled
    }()
    
    var sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitle("Send", for: .normal)
      //  button.isEnabled = false
        return button
    }()
    
    var messageInputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        return view
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageTableView.reloadData()
        
        if viewModel!.messages.count > 0 {
        let indexPath = IndexPath(row: (viewModel?.messages.count)! - 1, section: 0)
        messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       // sendMessageButton.roundCorner(corners: .bottomLeft, radius: 13)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     //   tapOnBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        

        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
      //  navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Chats", style: .plain, target: self, action: #selector(tapOnBack))
       
        title = viewModel?.dialog?.user.username
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapOnAdd))
        navigationController?.navigationBar.isTranslucent = false
        
        sendMessageButton.addTarget(self, action: #selector(tapOnSend), for: .touchUpInside)
        
      //  messageTableView.rowHeight = UITableView.automaticDimension
      //  messageTableView.estimatedRowHeight = 1000
        
        messageTableView.tableFooterView = UIView()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
       // messageTableView.separatorStyle = .none
   
        messageTextField.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func tapOnSend() {
        
        guard let text = messageTextField.text else { print("guard"); return }
        
        if !text.isEmptyOrWhitespase() {
            viewModel?.send(text: text)
            messageTableView.reloadData()
            messageTextField.text = nil
            messageTextField.resignFirstResponder()
            adjustContentHeight(animated: false)
            print("send")
        }
    }
    
    @objc func handleContentForKeyboard(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        
        let frameValue = keyboardInfo.cgRectValue
        
        let isShownKeyboard = notification.name == UIResponder.keyboardWillShowNotification
        bottomConstraint?.constant = isShownKeyboard ? -frameValue.height + view.safeAreaInsets.bottom : 0
       
        adjustContentHeight(animated: isShownKeyboard)
    }
    
    func adjustContentHeight(animated: Bool) {
       let messageBarHeight = -bottomConstraint!.constant + view.safeAreaInsets.bottom + 50
       let messagesContentHeight = view.frame.height - messageBarHeight

       let diferenceContent = messageTableView.contentSize.height - messagesContentHeight
   //  print(diferenceContent)
       UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
           self.view.layoutIfNeeded()
       }) { (completed) in
           if diferenceContent > 0 {
               let height = diferenceContent
               self.messageTableView.setContentOffset(CGPoint(x: 0, y: height), animated: animated)
            print("adjust")
           }
       }
        messageTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setupConstraints() {
        view.addSubview(messageTableView)
        view.addSubview(messageInputContainerView)
        messageInputContainerView.addSubview(messageTextField)
        messageInputContainerView.addSubview(sendMessageButton)
        
        
        sendMessageButton.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor).isActive = true
        sendMessageButton.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor,constant: -15).isActive = true
        sendMessageButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        sendMessageButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
     
        messageTextField.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor).isActive = true
        messageTextField.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor, constant: 15).isActive = true
        messageTextField.trailingAnchor.constraint(equalTo: sendMessageButton.leadingAnchor,constant: -10).isActive = true
        messageTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        bottomConstraint = messageInputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        messageInputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomConstraint?.isActive = true
        messageInputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        messageInputContainerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        messageTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messageTableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        messageTableView.bottomAnchor.constraint(equalTo: messageInputContainerView.topAnchor).isActive = true
    }
    
    @objc func tapOnAdd() {
     
        messageTableView.reloadData()
      
    }
    
    @objc func tapOnBack() {
//        guard let chatListViewController = navigationController?.previosViewController as? ChatListViewController, let user = viewModel?.user else {
//            print("back")
//            return
//        }
        
      //  chatListViewController.viewModel?.users.accept([user])
        navigationController?.popViewController(animated: true)
    }
    
}

extension ChatRoomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      //  print(tableView.frame.height, view.frame.height)
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTextField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let text = viewModel?.dialog?.messages[indexPath.row].text else { return 0 }
        return text.messageBounds().height + 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfrows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell
        
        guard let tableViewCell = cell, let dialog = viewModel?.dialog else { return UITableViewCell() }
        tableViewCell.selectionStyle = .none
        
        let message = dialog.messages[indexPath.row]
        let frame = message.text.messageBounds()
        
        if message.reciever.username == dialog.user.username {
            
            tableViewCell.messageTextView.roundCorner(corners: [.bottomLeft, .topLeft, .topRight], radius: 20)
            tableViewCell.messageTextView.frame = CGRect(x: view.frame.width - frame.width - 55, y: 10, width: frame.width + 40, height: frame.height + 20)
            
        } else {
            
            tableViewCell.messageTextView.roundCorner(corners: [.bottomRight, .bottomLeft, .topRight], radius: 20)
            tableViewCell.messageTextView.frame = CGRect(x: 15, y: 10, width: frame.width + 40, height: frame.height + 20)
            tableViewCell.messageTextView.backgroundColor = .systemGreen
        }
        
        tableViewCell.messageTextView.text = message.text
        
        return tableViewCell
    }
    
}

extension ChatRoomViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
      //  adjustContentHeight(animated: false)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
}
