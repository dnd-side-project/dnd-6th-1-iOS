//
//  PostButtonsView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit

class PostButtonsView: UIView {
    @IBOutlet var view: UIView!
    
    private static let NIB_NAME = "PostButtonsView"
    
    // awakeFromNib
    override func awakeFromNib() {
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(PostButtonsView.NIB_NAME, owner: self, options: nil)
        addSubview(view)
        setupLayout()
        setUpView()
    }
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
    
    private func setUpView() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
    }
}
