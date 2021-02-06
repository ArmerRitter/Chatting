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
        textfiled.placeholder = "Type message..."
        textfiled.backgroundColor = .white
        return textfiled
    }()
    
    var sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.setTitle("Send", for: .normal)
        
      //  button.setBackgroundImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
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
    var cellHeights = [IndexPath : CGFloat]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageTableView.reloadData()
        
        if (viewModel?.dialog?.unreadMessages.value.count)! > 0 {
        let indexPath = IndexPath(row: (viewModel?.dialog?.unreadMessages.value.count)! - 1, section: 0)
        messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
      // print("willLayout")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     //   tapOnBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
//        viewModel?.dialog?.unreadMessages.subscribe(onNext: { [unowned self] message in
//            self.messageTableView.reloadData()
//        }).disposed(by: viewModel!.bag)
        
        messageTableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        
        viewModel?.dialog?.unreadMessages.asObservable().bind(to: messageTableView.rx.items(cellIdentifier: "MessageCell", cellType: MessageCell.self)) { index, item, cell in
            
            let viewModelCell = MessageCellViewModel(message: item)
            cell.configure(viewModel: viewModelCell)
           
        }.disposed(by: viewModel!.bag)
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
      //  navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Chats", style: .plain, target: self, action: #selector(tapOnBack))
       
        title = viewModel?.dialog?.user.username
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapOnAdd))
        navigationController?.navigationBar.isTranslucent = false
        
        sendMessageButton.addTarget(self, action: #selector(tapOnSend), for: .touchUpInside)
        
        messageTableView.tableFooterView = UIView()
        messageTableView.delegate = self
       // messageTableView.separatorStyle = .none
   
       
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func tapOnSend() {
        
        guard let text = messageTextField.text else { return }
        
        if !text.isEmptyOrWhitespase() {
            viewModel?.send(text: text)
         //   messageTableView.reloadData()
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
  
       UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
           self.view.layoutIfNeeded()
       }) { (completed) in
           if diferenceContent > 0 {
               let height = diferenceContent
               self.messageTableView.setContentOffset(CGPoint(x: 0, y: height), animated: animated)
            print("adjust")
           }
        self.messageTableView.reloadData()
       }
        
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
        bottomConstraint?.isActive = true
        messageInputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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

extension ChatRoomViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      //  print(tableView.frame.height, view.frame.height)
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        
        guard let cell = cell as? MessageCell else { return }
       
        if cell.messageIsInput {
            cell.messageTextView.roundCorner(corners: [.bottomRight, .topLeft, .topRight], radius: 20)
            cell.messageTextView.backgroundColor = .systemGreen
        } else {
            cell.messageTextView.roundCorner(corners: [.bottomLeft, .topLeft, .topRight], radius: 20)
            cell.messageTextView.backgroundColor = .blue
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTextField.endEditing(true)
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let text = viewModel?.dialog?.unreadMessages.value[indexPath.row].text else { return 0 }
        return cellHeights[indexPath] ??  text.messageBounds().height + 40
    }
   /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfrows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        tableViewCell.selectionStyle = .none
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.configure(viewModel: cellViewModel)

        return tableViewCell
    }
    */
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
