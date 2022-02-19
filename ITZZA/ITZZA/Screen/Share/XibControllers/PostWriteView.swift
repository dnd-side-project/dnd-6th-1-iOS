//
//  PostWriteView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/19.
//

import UIKit
import SnapKit

class PostWriteView: UIView {
    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var contents: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureFont()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureFont()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.postWriteView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureFont() {
        title.textColor = .darkGray6
        title.font = UIFont.SpoqaHanSansNeoMedium(size: 15)
        title.setPlaceholderColor(.lightGray5)
        
        contents.textColor = .darkGray3
        contents.font = UIFont.SpoqaHanSansNeoRegular(size: 15)
        contents.setAllMarginToZero()
    }
    
    func setTitlePlaceholder(_ placeholder: String) {
        title.placeholder = placeholder
    }
    
    func setContentsPlaceholder(_ placeholder: String) {
        contents.setTextViewPlaceholder(placeholder)
    }
}
