//
//  MessageCell.swift
//  Chatting
//
//  Created by Yuriy Balabin on 27.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit


class MessageCell: UITableViewCell {
    
    var messageTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
      //  view.backgroundColor = .blue
        view.isEditable = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 17)
        view.isScrollEnabled = false
        view.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        view.layer.masksToBounds = true
        return view
    }()
    
    var messageIsInput: Bool = false
    
    func configure(viewModel: MessageCellViewModelType) {
        
        guard let masterUser = viewModel.masterUser else { return }
        
        let frame = viewModel.messageSize
        
        if masterUser.username == viewModel.messageSender {
             
          //  messageTextView.roundCorner(corners: [.bottomLeft, .topLeft, .topRight], radius: 20)
            messageIsInput = false
            messageTextView.frame = CGRect(x: UIScreen.main.bounds.width - frame.width - 55, y: 10, width: frame.width + 40, height: frame.height + 20)
                   
        } else {
                   
         //  messageTextView.roundCorner(corners: [.bottomRight, .bottomLeft, .topRight], radius: 20)
           messageIsInput = true
           messageTextView.frame = CGRect(x: 15, y: 10, width: frame.width + 40, height: frame.height + 20)
           //messageTextView.backgroundColor = .systemGreen
        }
        
        messageTextView.text = viewModel.messageText
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(messageTextView)
        self.selectionStyle = .none
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
