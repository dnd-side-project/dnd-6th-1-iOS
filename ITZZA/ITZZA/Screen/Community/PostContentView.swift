//
//  PostContentView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit

class PostContentView: UIView {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UILabel!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
        configureText()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureText()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.postContentView) else { return }
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
        
        postContent.setLineBreakMode()
    }
    
    private func configureText() {
        postTitle.textColor = .darkGray6
        postTitle.font = UIFont.SpoqaHanSansNeoMedium(size: 15)
        
        postContent.textColor = .darkGray3
        postContent.font = UIFont.SpoqaHanSansNeoRegular(size: 15)
    }
}
