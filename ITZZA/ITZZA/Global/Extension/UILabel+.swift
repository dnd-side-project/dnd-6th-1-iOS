//
//  UILabel+.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/09.
//

import UIKit

extension UILabel {
    func setLineBreakMode() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        lineBreakMode = .byCharWrapping
    }
}
