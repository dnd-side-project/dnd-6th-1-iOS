//
//  PasswordView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/07.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordView: UIView {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var validConfirmPasswordLabel: UILabel!
    @IBOutlet weak var passwordEyeButton: UIButton!
    
    var disposeBag = DisposeBag()
    let validation = Validation()
    let passwordVM = PasswordVM()
    let isValidPassword = BehaviorRelay(value: false)
    
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
    
    func setContentView() {
        insertXibView(with: Identifiers.passwordView)
    }
    
}

// MARK: - Change UI
extension PasswordView {
    func setInitialValue() {
        passwordTextField.textContentType = .newPassword
        confirmPasswordTextField.textContentType = .newPassword
        validPasswordLabel.isHidden = true
        validConfirmPasswordLabel.isHidden = true
    }
    
    func didTapPasswordEyeButton(_ isEyeOn: Bool) {
        if isEyeOn {
            passwordEyeButton.setImage(UIImage(named: "PasswordEyeOff"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordEyeButton.setImage(UIImage(named: "PasswordEyeOn"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
}

// MARK: - Bindings
extension PasswordView {
    private func bindUI() {
        passwordTextField.rx.text.orEmpty
            .bind(to: validation.passwordText)
            .disposed(by: disposeBag)
        
        passwordEyeButton.rx.tap
            .asObservable()
            .map { [weak self] in
                (self?.passwordEyeButton.currentImage)!
            }
            .bind(to: validation.eyeOnOff)
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx.text.orEmpty
            .withUnretained(self)
            .bind(onNext: { owner, pw in
                owner.passwordVM.comparePassword(owner.passwordTextField.text ?? "", pw)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        validation.isPasswordValid.asDriver()
            .drive(validPasswordLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation.isEyeOn.asDriver()
            .drive(onNext: { [weak self] eyeStatus in
                guard let self = self else { return }
                self.didTapPasswordEyeButton(eyeStatus)
            })
            .disposed(by: disposeBag)

        passwordVM.isEqualPassword.asDriver()
            .drive(onNext: { [weak self] isSame in
                guard let self = self else { return }
                self.validConfirmPasswordLabel.isHidden = isSame
                self.isValidPassword.accept(isSame)
            })
            .disposed(by: disposeBag)
    }
}
