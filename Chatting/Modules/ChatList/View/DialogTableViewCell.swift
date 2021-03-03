//
//  DialogTableViewCell.swift
//  Chatting
//
//  Created by Yuriy Balabin on 21.01.2021.
//  Copyright © 2021 None. All rights reserved.
//

import UIKit
import RxSwift

class DialogTableViewCell: UITableViewCell {

    private let userImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "avatar1.png")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.layer.borderWidth = 3
        view.layer.borderColor = #colorLiteral(red: 0.05490196078, green: 0.2901960784, blue: 0.5254901961, alpha: 1)
        return view
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let unreadMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        return label
    }()
    
    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    func configure(viewModel: DialogTableViewCellViewModelType) {
        
        usernameLabel.text = viewModel.username
        lastMessageLabel.text = viewModel.lastMessage
        unreadMessageLabel.text = String(viewModel.unreadMeassageCount)
           
        if viewModel.unreadMeassageCount == 0 {
            unreadMessageLabel.isHidden = true
        } else {
            unreadMessageLabel.isHidden = false
        }

    }
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        addSubview(usernameLabel)
        addSubview(unreadMessageLabel)
        addSubview(userImageView)
        addSubview(lastMessageLabel)
        
        lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5).isActive = true
        lastMessageLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 15).isActive = true
        lastMessageLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2).isActive = true
        
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        unreadMessageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        unreadMessageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        unreadMessageLabel.widthAnchor.constraint(equalToConstant: 26).isActive = true
        unreadMessageLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 15).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
