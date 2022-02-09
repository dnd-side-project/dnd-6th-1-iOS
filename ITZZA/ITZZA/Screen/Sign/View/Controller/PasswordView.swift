//
//  PasswordView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/07.
//

import UIKit

class PasswordView: UIView {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validPasswordLabel: UILabel!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var validCheckPasswordLabel: UILabel!
    
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
    
    func setInitialValue() {
        passwordTextField.isSecureTextEntry = false
        checkPasswordTextField.isSecureTextEntry = false
    }
    
    func setContentView() {
        guard let view = loadXibView(with: Identifiers.passwordView) else { return }
        self.addSubview(view)
    }
    
}
