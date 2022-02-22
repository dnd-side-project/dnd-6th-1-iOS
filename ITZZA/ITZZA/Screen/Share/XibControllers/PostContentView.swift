//
//  PostContentView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit
import SnapKit

class PostContentView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var contents: UILabel!
    
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
        guard let view = loadXibView(with: Identifiers.postContentView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureFont() {
        title.textColor = .lightGray5
        title.font = UIFont.SpoqaHanSansNeoBold(size: 15)
        
        contents.setLineBreakMode()
        contents.textColor = .lightGray5
        contents.font = UIFont.SpoqaHanSansNeoRegular(size: 15)
    }
}
