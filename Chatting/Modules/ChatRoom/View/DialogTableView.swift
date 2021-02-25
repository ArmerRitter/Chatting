//
//  DialogTableView.swift
//  Chatting
//
//  Created by Yuriy Balabin on 16.02.2021.
//  Copyright © 2021 None. All rights reserved.
//

import UIKit

class DialogTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
