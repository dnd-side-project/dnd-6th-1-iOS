//
//  ChatInputView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/07.
//

import UIKit
import SnapKit

class ChatInputView: UIView {
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
        setTextField()
        setViewShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        setTextField()
        setViewShadow()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.chatInputView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setTextField() {
        textInputField.layer.cornerRadius = 4
        textInputField.backgroundColor = .background
        textInputField.textColor = .lightGray6
        textInputField.addLeftPadding()
        textInputField.placeholder = "댓글을 입력해주세요"
    }
    
    func setViewShadow(){
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
    }
}
