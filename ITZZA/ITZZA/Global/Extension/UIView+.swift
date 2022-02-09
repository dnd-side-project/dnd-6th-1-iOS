//
//  UIView+.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/08.
//

import UIKit

extension UIView {
    func loadXibView(with xibName: String) -> UIView? {
        return Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView
    }
}
