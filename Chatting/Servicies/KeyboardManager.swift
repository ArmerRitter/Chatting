//
//  KeyboardManager.swift
//  Chatting
//
//  Created by Yuriy Balabin on 03.02.2021.
//  Copyright © 2021 None. All rights reserved.
//

import UIKit

protocol KeyboardManagerDelegate: class {
 //   func thresholdHeight() -> CGFloat
//    func constantOfAdjustedConstraint() -> CGFloat
//    func adjustContentHeight(keyBoard isShown: Bool)
    func keyboardDidAppear(keyboard frame: CGRect)
    func keyboardDidDiasappear(keyboard frame: CGRect)
}

class KeyboardManager {
    
   // var height: CGFloat
  //  var constraint: NSLayoutConstraint
    var homeConstant: CGFloat = 0
    var altConstant: CGFloat = 0
    private var isShownKeyboard: Bool = false
    private var keyboardFrame: CGRect = .zero
    
    weak var delegate: KeyboardManagerDelegate?
    
    @objc func handleForKeyboard(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let delegate = delegate
        else { return }
        
        keyboardFrame = keyboardInfo.cgRectValue
        
      //  var height = delegate.thresholdHeight()
        var differenceHeight: CGFloat = 0
        
     //   guard height < keyboardFrame.origin.y else { return }
        
        isShownKeyboard = notification.name == UIResponder.keyboardWillShowNotification
      //  print(keyboardFrame.origin.y)
        if isShownKeyboard {
            delegate.keyboardDidAppear(keyboard: keyboardFrame)
        } else {
            delegate.keyboardDidDiasappear(keyboard: keyboardFrame)
        }
        
    }
    
    func adjustContentHeight(current height: CGFloat) {
        
//         let messageBarHeight = -constraint!.constant + view.safeAreaInsets.bottom + 50
//         let messagesContentHeight = view.frame.height - messageBarHeight
//
//         let diferenceContent = messageTableView.contentSize.height - messagesContentHeight
//
//        delegate?.adjustContentHeight(current: height)
      }
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
}
