//
//  UIColor+.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/25.
//

import UIKit

extension UIColor {
    @nonobjc class var main1: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var textFieldBackgroundColor: UIColor {
        return UIColor(red: 0.963, green: 0.963, blue: 0.971, alpha: 1)
    }
    
    @nonobjc class var loginButtonBackgroundColor: UIColor {
        return UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}
