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
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var upperLineView: UIView!
    @IBOutlet weak var lowerLineView: UIView!
    
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
        validPasswordLabel.textColor = .lightGray5
        validPasswordLabel.font = .SpoqaHanSansNeoRegular(size: 12)
        validConfirmPasswordLabel.isHidden = true
        validConfirmPasswordLabel.textColor = .lightGray5
        validConfirmPasswordLabel.font = .SpoqaHanSansNeoRegular(size: 12)
        stepLabel.textColor = .primary
        stepLabel.font = .SpoqaHanSansNeoBold(size: 15)
        descriptionLabel.textColor = .darkGray6
        descriptionLabel.font = .SpoqaHanSansNeoBold(size: 20)
    }
    
    private func changeLineViewColor(_ lineView: UIView, _ flag: Bool) {
        if flag {
            lineView.backgroundColor = .primary
        } else {
            lineView.backgroundColor = .lightGray5
        }
    }
    
    private func changePasswordLabel(_ flag: Bool) {
        if flag {
            validPasswordLabel.textColor = .primary
            validPasswordLabel.text = "사용가능한 비밀번호입니다."
        } else {
            validPasswordLabel.textColor = .lightGray5
            validPasswordLabel.text = "유효하지 않은 비밀번호입니다."
        }
    }
    
    private func changeComfirmPasswordLabel(_ flag: Bool) {
        if flag {
            validConfirmPasswordLabel.textColor = .primary
            validConfirmPasswordLabel.text = "비밀번호가 일치합니다."
        } else {
            validConfirmPasswordLabel.textColor = .lightGray5
            validConfirmPasswordLabel.text = "비밀번호가 일치하지 않습니다."
        }
    }
    
    func didTapPasswordEyeButton(_ isEyeOn: Bool) {
        if isEyeOn {
            passwordEyeButton.setImage(UIImage(named: "PasswordEyeOff"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        } else {
            passwordEyeButton.setImage(UIImage(named: "PasswordEyeOn"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        }
    }
}

// MARK: - Bindings
extension PasswordView {
    private func bindUI() {
        passwordTextField.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.validPasswordLabel.isHidden = false
            })
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.validConfirmPasswordLabel.isHidden = false
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: validation.passwordText)
            .disposed(by: disposeBag)
 
        passwordEyeButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .map { owner, _ in
                owner.passwordEyeButton.currentImage?
                    .isEqual(UIImage(named: "PasswordEyeOn")) ?? false
            }
            .bind(onNext: { [weak self] status in
                guard let self = self else { return }
                self.validation.checkEyeOn(status)
            })
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
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.changeLineViewColor(self.upperLineView, flag)
                self.changePasswordLabel(flag)
            })
            .disposed(by: disposeBag)
        
        validation.isEyeOn.asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] eyeStatus in
                guard let self = self else { return }
                self.didTapPasswordEyeButton(eyeStatus)
            })
            .disposed(by: disposeBag)

        passwordVM.isEqualPassword.asDriver()
            .drive(onNext: { [weak self] isSame in
                guard let self = self else { return }
                self.isValidPassword.accept(isSame)
                self.changeLineViewColor(self.lowerLineView, isSame)
                self.changeComfirmPasswordLabel(isSame)
            })
            .disposed(by: disposeBag)
    }
}
