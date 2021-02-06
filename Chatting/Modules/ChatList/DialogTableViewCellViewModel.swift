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
    var unreadMeassageCount: Int { get }
    var dialog: Dialog { get set }
    var bag: DisposeBag { get }
}

class DialogTableViewCellViewModel: DialogTableViewCellViewModelType {
   // var unreadMeassageCount: Int
    
    
    var dialog: Dialog
    var bag = DisposeBag()
    
    var username: String {
        return dialog.user.username
    }
    
    var unreadMeassageCount: Int {
        return dialog.unreadMessageCounter.value
    }
    
    init(dialog: Dialog) {
        self.dialog = dialog
       // self.unreadMeassageCount = 0
    }    
    
}
