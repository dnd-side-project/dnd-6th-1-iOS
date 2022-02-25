//
//  UIButton+.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit

extension UIButton {
    func setImageToggle(_ isBtnSelected: Bool, _ defaultImage: UIImage, _ selectedImage: UIImage) {
        if isBtnSelected {
            self.setImage(selectedImage, for: .normal)
        } else {
            self.setImage(defaultImage, for: .normal)
        }
    }
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
