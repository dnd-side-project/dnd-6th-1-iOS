//
//  PostContentView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit

class PostContentView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UITextView!
    
    // awakeFromNib
    override func awakeFromNib() {
        initWithNib()
        setUpView()
        setContents()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(Identifiers.postContentView, owner: self, options: nil)
        addSubview(view)
        
        setContents()
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
        view.backgroundColor = .clear
    }
    
    func setContents() {
        postContent.isScrollEnabled = false
        postContent.isUserInteractionEnabled = false
        postContent.backgroundColor = .clear
    }
}
