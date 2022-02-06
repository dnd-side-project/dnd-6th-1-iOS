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
}
