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

   var bag = DisposeBag()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    
    let unreadMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.text = "8"
        label.textAlignment = .center
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        return label
    }()
    
    func configure(viewModel: DialogTableViewCellViewModelType) {
        
        usernameLabel.text = viewModel.username
        
        if viewModel.unreadMeassageCount == 0 {
            unreadMessageLabel.isHidden = true
        } else {
            unreadMessageLabel.isHidden = false
        }
        
        viewModel.dialog.unreadMessages.subscribe(onNext: { [unowned self] messages in
            self.unreadMessageLabel.text = "\(messages.count)"
        }).disposed(by: bag)
    }
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        addSubview(usernameLabel)
        addSubview(unreadMessageLabel)
        
        unreadMessageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        unreadMessageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        unreadMessageLabel.widthAnchor.constraint(equalToConstant: 26).isActive = true
        unreadMessageLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
