//
//  UserCellViewModel.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import RxSwift


protocol DialogTableViewCellViewModelType {
    var username: String { get }
    var lastMessage: String { get }
    var unreadMeassageCount: Int { get }
}

class DialogTableViewCellViewModel: DialogTableViewCellViewModelType {
    
    var dialog: Dialog
    var bag = DisposeBag()
    
    var username: String {
        return dialog.user.username
    }
    
    var unreadMeassageCount: Int {
        return dialog.unreadMessageCounter.value
    }
    
    var lastMessage: String {
        guard let text = dialog.messages.value.last?.text else { return "" }
        return text
    }
    
    init(dialog: Dialog) {
        self.dialog = dialog
    }    
    
}
