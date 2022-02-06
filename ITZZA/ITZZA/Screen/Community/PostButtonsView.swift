//
//  PostButtonsView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit

class PostButtonsView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCnt: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    // awakeFromNib
    override func awakeFromNib() {
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(Identifiers.postButtonsView, owner: self, options: nil)
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
