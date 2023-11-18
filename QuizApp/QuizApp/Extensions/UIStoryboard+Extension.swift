//
//  UIStoryboard+Extension.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 12/11/23.
//

import UIKit

extension UIStoryboard {
    
    static let main = UIStoryboard(name: "Main", bundle: nil)
    
    func instantiate<T>() -> T {
        return instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
