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
    
    var messageTextField: UITextField = {
        let textfiled = UITextField()
        textfiled.translatesAutoresizingMaskIntoConstraints = false
        textfiled.layer.cornerRadius = 17
        textfiled.layer.masksToBounds = true
        textfiled.layer.borderColor = UIColor.lightGray.cgColor
        textfiled.layer.borderWidth = 1
        textfiled.placeholder = "   Type message"
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
        let indexPath = IndexPath(row: mess.count - 1, section: 0)
        messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       // sendMessageButton.roundCorner(corners: .bottomLeft, radius: 13)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    guard let user = viewModel?.user else { return }
      
        view.backgroundColor = .white
        
        setupView()
        setupConstraints()
       // adjustContentHeight(animated: false)
    }
    
    func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(tapOnBack))
       
        title = viewModel?.user?.username
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapOnAdd))
        navigationController?.navigationBar.isTranslucent = false
        
        messageTableView.tableFooterView = UIView()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        messageTableView.separatorStyle = .none
   
        messageTextField.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
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
     print(diferenceContent)
       UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
           self.view.layoutIfNeeded()
       }) { (completed) in
           if diferenceContent > 0 {
               let height = diferenceContent
               self.messageTableView.setContentOffset(CGPoint(x: 0, y: height), animated: animated)
           }
       }
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
        guard let user = viewModel?.user else { return }
        let mess = Message(sender: "Q7", reciever: user, text: "hallo 7")
      //  service.disconnect()
        
     //   viewModel?.service?.send(mess) { result in
            
     //   }
        
     //   print( self.tableView.contentOffset.y)
    }
    
    @objc func tapOnBack() {
        guard let chatListViewController = navigationController?.previosViewController as? ChatListViewController, let user = viewModel?.user else {
            return
        }
        
        chatListViewController.viewModel?.users.accept([user])
        navigationController?.popViewController(animated: true)
    }
    
    var mess = ["A collection of optional methods that you implement to make a search bar control functional","The mathematical constant pi","Above is the current function I use to determine the height but it is not working. I would greatly appreciate any help I can get. I would perfer the answer in Swift and not Objective C"]
   
}

extension ChatRoomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      //  print(tableView.frame.height, view.frame.height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTextField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      //  let opthions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
      //  let frame = NSString(string: mess).boundingRect(with: CGSize(width: 250, height: 1000), options: opthions, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)], context: nil)
       // print(view.frame.width)
        
        return mess[indexPath.row].messageBounds().height + 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mess.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.selectionStyle = .none
        //cell.backgroundColor = .yellow
        cell.messageTextView.roundCorner(corners: [.bottomLeft, .topLeft, .topRight], radius: 20)
        
        let frame = mess[indexPath.row].messageBounds()
        
        cell.messageTextView.frame = CGRect(x: view.frame.width - frame.width - 55, y: 10, width: frame.width + 40, height: frame.height + 20)
        
        cell.messageTextView.text = mess[indexPath.row]
        
        return cell
    }
    
}

extension ChatRoomViewController: UITextFieldDelegate {
    
    
    
}
