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
        view.backgroundColor = .blue
        view.isEditable = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 17)
        view.isScrollEnabled = false
        view.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(messageTextView)
        
       // messageTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
      //  messageTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
         //  messageTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -100).isActive = true
     //   messageTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
