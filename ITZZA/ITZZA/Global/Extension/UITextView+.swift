//
//  UITextView+.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit

extension UITextView {
    func setAllMarginToZero() {
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
    func setTextViewToViewer() {
        isScrollEnabled = false
        isUserInteractionEnabled = false
    }
    func setTextViewPlaceholder(_ placeholder: String) {
        if text == "" {
            text = placeholder
            textColor = .lightGray6
        } else if text == placeholder {
            text = ""
            textColor = .darkGray3
        }
    }
}
