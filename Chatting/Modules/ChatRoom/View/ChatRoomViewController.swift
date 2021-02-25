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


class ChatRoomViewController: UIViewController, UIScrollViewDelegate {
    
    var viewModel: ChatRoomViewModelType?
    let keyboardManager = KeyboardManager()
    
    private let dialogTableView: DialogTableView = {
        let table = DialogTableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let enterMessageTextField: MessageTextField = {
        let textfiled = MessageTextField()
        textfiled.translatesAutoresizingMaskIntoConstraints = false
        textfiled.layer.cornerRadius = 17
        textfiled.layer.masksToBounds = true
        textfiled.placeholder = "Type message..."
        textfiled.backgroundColor = .white
        textfiled.returnKeyType = .done
        return textfiled
    }()
    
    private let sendMessageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "send.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        return button
    }()
    
    private let enterMessageBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        return view
    }()
    
    private let dialogScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .white
        return scroll
    }()
    
    private var bottomConstraint: NSLayoutConstraint?
    private var tableViewHeight: NSLayoutConstraint?
    private var cellHeights = [IndexPath : CGFloat]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            jumpToBottom()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHeight?.constant = dialogTableView.contentSize.height
        dialogScrollView.contentSize = CGSize(width: view.frame.width, height: tableViewHeight!.constant)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
 
       viewModel?.dialog?.unreadMessages.asObservable().bind(to: dialogTableView.rx.items) { [unowned self] (tv, row, item) -> UITableViewCell in

            if item.sender.username == StorageManager.selfSender?.username {
                
                let cell = tv.dequeueReusableCell(withIdentifier: "MessageOutputCell", for: IndexPath(row: row, section: 0)) as! MessageOutputCell
                
                let viewModelCell = MessageCellViewModel(message: item)
                cell.configure(viewModel: viewModelCell)
                
                if self.dialogScrollView.contentSize.height > self.dialogScrollView.frame.height {
                   self.jumpToBottom()
                }
                
                return cell
            } else {
                
                let cell = tv.dequeueReusableCell(withIdentifier: "MessageInputCell", for: IndexPath(row: row, section: 0)) as! MessageInputCell
                
                let viewModelCell = MessageCellViewModel(message: item)
                cell.configure(viewModel: viewModelCell)
                
                if self.dialogScrollView.contentSize.height > self.dialogScrollView.frame.height {
                   self.jumpToBottom()
                }
                
                return cell
            }
          
        }.disposed(by: viewModel!.bag)
      
    }
    
    func setupView() {
      
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        title = viewModel?.dialog?.user.username
        
        dialogTableView.register(MessageOutputCell.self, forCellReuseIdentifier: "MessageOutputCell")
        dialogTableView.register(MessageInputCell.self, forCellReuseIdentifier: "MessageInputCell")
        dialogTableView.tableFooterView = UIView()
        dialogTableView.separatorStyle = .none
        dialogTableView.isScrollEnabled = false
        
        enterMessageTextField.rightView = sendMessageButton
        enterMessageTextField.rightViewMode = .always
        
        dialogTableView.delegate = self
        dialogScrollView.delegate = self
        enterMessageTextField.delegate = self
        keyboardManager.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapOnAdd))
        
        sendMessageButton.addTarget(self, action: #selector(tapOnSend), for: .touchUpInside)
    }
    
    func setupConstraints() {
       
       view.addSubview(dialogScrollView)
       dialogScrollView.addSubview(dialogTableView)
       view.addSubview(enterMessageBackgroundView)
       enterMessageBackgroundView.addSubview(enterMessageTextField)
       

       enterMessageTextField.centerYAnchor.constraint(equalTo: enterMessageBackgroundView.centerYAnchor).isActive = true
       enterMessageTextField.leadingAnchor.constraint(equalTo: enterMessageBackgroundView.leadingAnchor, constant: 15).isActive = true
       enterMessageTextField.trailingAnchor.constraint(equalTo: enterMessageBackgroundView.trailingAnchor ,constant: -15).isActive = true
       enterMessageTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
  
       dialogScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
       dialogScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
       dialogScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
       dialogScrollView.bottomAnchor.constraint(equalTo: enterMessageBackgroundView.topAnchor).isActive = true
       
       bottomConstraint = enterMessageBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
       bottomConstraint?.isActive = true
       enterMessageBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
       enterMessageBackgroundView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
   
       dialogTableView.topAnchor.constraint(equalTo: dialogScrollView.topAnchor).isActive = true
       dialogTableView.leadingAnchor.constraint(equalTo: dialogScrollView.leadingAnchor).isActive = true
       dialogTableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
       tableViewHeight = dialogTableView.heightAnchor.constraint(equalToConstant: 0)
       tableViewHeight?.isActive = true
    }
    
    
    func jumpToBottom(){
        DispatchQueue.main.async {
         
        }
            let delta = self.dialogTableView.contentSize.height - self.dialogScrollView.frame.height
            self.dialogScrollView.contentOffset.y = delta
        //    print(self.dialogScrollView.frame.height, delta)
    //    }
    }
    
    @objc func tapOnSend() {
        
        guard let text = enterMessageTextField.text else { return }
        
        if !text.isEmptyOrWhitespase() {
            
            viewModel?.send(text: text)
            enterMessageTextField.text = nil
        }
    }
    
    @objc func tapOnAdd() {
       print(dialogTableView.contentSize.height)
        jumpToBottom()
    }
}

extension ChatRoomViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        enterMessageTextField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let text = viewModel?.dialog?.unreadMessages.value[indexPath.row].text else { return 0 }
        return cellHeights[indexPath] ??  text.messageBounds().height + 25
    }
}

extension ChatRoomViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       enterMessageTextField.resignFirstResponder()
       return true
    }
}

extension ChatRoomViewController: KeyboardManagerDelegate {
    
    func keyboardWillShow(keyboard frame: CGRect, duration: Double, options: UIView.AnimationOptions) {
        
        bottomConstraint?.constant =  -frame.height + view.safeAreaInsets.bottom

        let keyboardHeight = frame.height
        let shiftHeight = dialogScrollView.contentOffset.y + keyboardHeight - view.safeAreaInsets.bottom
        
        guard !keyboardManager.keyboardIsShown else { return }
      
        dialogScrollView.contentOffset.y = shiftHeight
    
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    func keyboardWillHide(keyboard frame: CGRect, duration: Double, options: UIView.AnimationOptions) {
       
        bottomConstraint?.constant = 0

        let keyboardHeight = frame.height
        let shiftHeight = dialogScrollView.contentOffset.y - keyboardHeight + view.safeAreaInsets.bottom

        self.dialogScrollView.contentOffset.y = shiftHeight

        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
}
