//
//  MessageInputCell.swift
//  Chatting
//
//  Created by Yuriy Balabin on 10.02.2021.
//  Copyright © 2021 None. All rights reserved.
//

import UIKit



class MessageInputCell: UITableViewCell {
    
    
    private let messageTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 17)
        view.textContainerInset = UIEdgeInsets(top: 7, left: 5, bottom: 7, right: 5)
        view.isEditable = false
        view.isScrollEnabled = false
        view.layer.cornerRadius = 7
        view.backgroundColor = #colorLiteral(red: 0.7294117647, green: 0.7725490196, blue: 0.8549019608, alpha: 1)
        view.textColor = #colorLiteral(red: 0.01568627451, green: 0.07450980392, blue: 0.2156862745, alpha: 1)
        return view
    }()
    
    private let messageTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var messageSize = CGSize(width: 0, height: 0)
        
    
    func configure(viewModel: MessageCellViewModelType) {
            
            messageSize = viewModel.messageSize
            messageTextView.text = viewModel.messageText
            messageTimeLabel.text = viewModel.messageTime
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageView.frame = CGRect(x: 15, y: 5, width: messageSize.width + 25, height: messageSize.height + 15)
                
        messageTextView.topAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
        
        messageTimeLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        messageTimeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        messageTimeLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10).isActive = true
        messageTimeLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -5).isActive = true
    }
    
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            self.addSubview(messageView)
            messageView.addSubview(messageTextView)
            messageView.addSubview(messageTimeLabel)
            self.selectionStyle = .none
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        

}
