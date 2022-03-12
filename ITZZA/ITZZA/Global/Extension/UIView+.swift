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
    
    func transfromToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
}
