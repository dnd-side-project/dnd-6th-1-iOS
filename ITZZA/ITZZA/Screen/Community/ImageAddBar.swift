//
//  ImageAddBar.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift

class ImageAddBar: UIView {
    @IBOutlet weak var addImageButton: UIButton!
    
    let bag = DisposeBag()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
    }
    
    private func setContentView() {
        guard let view = loadViewFromNib(with: Identifiers.imageAddBar) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
