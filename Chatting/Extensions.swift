//
//  Extensions.swift
//  Chatting
//
//  Created by Yuriy Balabin on 27.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit


extension UIView {
    
    func roundCorner(corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

extension String {
    
    func messageBounds() -> CGSize {
        var dopWidth: CGFloat = 0
        var dopHight: CGFloat = 0
        
        let constraintRect = CGSize(width: UIScreen.main.bounds.width / 1.65, height: 1000)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
       
        let boundingBoxWithTime = (self + "aaaa").boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
        
        if boundingBoxWithTime.height > boundingBox.height {
            dopHight = 15
        }
        
        if boundingBoxWithTime.width > boundingBox.width {
            dopWidth = boundingBoxWithTime.width - boundingBox.width
        }
        
        return CGSize(width: boundingBox.width + dopWidth, height: boundingBox.height + dopHight)
      }
    
    
    func isEmptyOrWhitespase() -> Bool {
        self.trimmingCharacters(in: .whitespaces) == ""
    }
    
   
    
}



