//
//  EmailView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/08.
//

import UIKit

class EmailView: UIView {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailValidLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        setInitialValue()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        setInitialValue()
    }
    
    private func setInitialValue() {
        emailTextField.returnKeyType = .done
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
        emailTextField.enablesReturnKeyAutomatically = true
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.placeholder = "이메일 입력"
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.emailView) else { return }
        self.addSubview(view)
    }
    
}
