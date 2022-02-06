//
//  ChatInputView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/07.
//

import UIKit

class ChatInputView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // awakeFromNib
    override func awakeFromNib() {
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(Identifiers.chatInputView, owner: self, options: nil)
        addSubview(view)
        setupLayout()
        setUpView()
        setTextField()
        setViewShadow()
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
    }
    
    func setTextField() {
        textInputField.layer.cornerRadius = 4
        textInputField.backgroundColor = .systemGray6
        textInputField.addLeftPadding()
        textInputField.placeholder = "댓글을 입력해주세요"
    }
    
    func setViewShadow(){
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
    }
}
