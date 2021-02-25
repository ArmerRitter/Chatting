//
//  KeyboardManager.swift
//  Chatting
//
//  Created by Yuriy Balabin on 03.02.2021.
//  Copyright © 2021 None. All rights reserved.
//

import UIKit

protocol KeyboardManagerDelegate: class {
    func keyboardWillShow(keyboard frame: CGRect, duration: Double, options: UIView.AnimationOptions)
    func keyboardWillHide(keyboard frame: CGRect, duration: Double, options: UIView.AnimationOptions)
}

class KeyboardManager {
    
    weak var delegate: KeyboardManagerDelegate?
    var keyboardIsShown: Bool = false
    
    @objc func handleForKeyboard(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
              let delegate = delegate
        else { return }
        

        let options = UIView.AnimationOptions(rawValue: curve.uintValue)
       
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            
            delegate.keyboardWillShow(keyboard: endFrame.cgRectValue, duration: duration, options: options)
            keyboardIsShown = true
        case UIResponder.keyboardWillHideNotification:
           
            delegate.keyboardWillHide(keyboard: endFrame.cgRectValue, duration: duration, options: options)
            keyboardIsShown = false
        default:
            return
        }
    }
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
}
