//
//  PostContentView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit

class PostContentView: UIView {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UITextView!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
        setContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        setContents()
    }
    
    private func setContentView() {
        guard let view = loadViewFromNib(with: Identifiers.postContentView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
    }
    
    func setContents() {
        postContent.isScrollEnabled = false
        postContent.isUserInteractionEnabled = false
        postContent.backgroundColor = .clear
    }
}
