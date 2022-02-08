//
//  UIView+.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/08.
//

import UIKit

extension UIView {
    func loadViewFromNib(with xibName: String) -> UIView? {
        return Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView
    }
}
