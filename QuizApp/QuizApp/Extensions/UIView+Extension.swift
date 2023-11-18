//
//  UIView+Extension.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 12/11/23.
//

import UIKit

extension UIView {
    
    func setRadiusAndShadow(radius: CGFloat = 20) {
        
        layer.cornerRadius = radius
        clipsToBounds = true
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 3, height: 5)
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.masksToBounds = false
    }
}


