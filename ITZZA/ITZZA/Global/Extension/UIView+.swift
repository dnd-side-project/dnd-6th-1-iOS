//
//  UIView+.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/08.
//

import UIKit
import SnapKit

extension UIView {
    func loadXibView(with xibName: String) -> UIView? {
        return Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView
    }
    
    func insertXibView(with xibName: String) {
        guard let view = loadXibView(with: xibName) else { return }
        addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
