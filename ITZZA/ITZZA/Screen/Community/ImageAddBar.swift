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
    @IBOutlet weak var message: UILabel!
    
    let bag = DisposeBag()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
        configureFont()
        setViewShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureFont()
        setViewShadow()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.imageAddBar) else { return }
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
    
    private func configureFont() {
        message.textColor = .lightGray6
        message.font = UIFont.SpoqaHanSansNeoRegular(size: 10)
        
        addImageButton.tintColor = .primary
        addImageButton.setTitleColor(.black, for: .normal)
        addImageButton.titleLabel?.font = UIFont.SpoqaHanSansNeoMedium(size: 13)
    }
    
    func setViewShadow(){
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 0.5
        layer.shadowColor = UIColor.lightGray6.cgColor
        layer.shadowOpacity = 1
    }
}
