//
//  EmailView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/08.
//

import UIKit
import RxSwift
import RxCocoa

class EmailView: UIView {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailValidLabel: UILabel!
    
    var disposeBag = DisposeBag()
    let isValidEmail = BehaviorRelay(value: false)
    let validation = Validation()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        bindUI()
        bindVM()
        setInitialValue()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        bindUI()
        bindVM()
        setInitialValue()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.emailView)
    }
}

// MARK: - Bindings
extension EmailView {
    private func bindUI() {
        emailTextField.rx.text.orEmpty
            .bind(to: validation.emailText)
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        validation.isEmailVaild.asDriver()
            .do(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.isValidEmail.accept(flag)
            })
            .drive(emailValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: - Change UI
extension EmailView {
    private func setInitialValue() {
        emailTextField.returnKeyType = .done
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
        emailTextField.enablesReturnKeyAutomatically = true
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.placeholder = "이메일 입력"
        emailValidLabel.isHidden = true
    }
}
