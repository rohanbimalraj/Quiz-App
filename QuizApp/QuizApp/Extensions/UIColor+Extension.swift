//
//  UIColor+Extension.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 12/11/23.
//

import UIKit

extension UIColor {
    
    convenience init?(appColor: AppColor) {
        self.init(named: appColor.rawValue)
    }
    
}

enum AppColor: String {
    
    case atoll = "Atoll"
    case halfAndHalf = "Half and Half"
    case olivine = "Olivine"
    case wattle = "Wattle"
}
