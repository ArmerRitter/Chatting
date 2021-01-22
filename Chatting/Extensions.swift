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
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension String {
    
    func messageBounds() -> CGSize {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width / 1.65, height: 1000)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)

        return CGSize(width: boundingBox.width, height: boundingBox.height)
    }
    
    func isEmptyOrWhitespase() -> Bool {
        self.trimmingCharacters(in: .whitespaces) == ""
    }
}


