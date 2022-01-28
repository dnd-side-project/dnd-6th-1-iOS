//
//  SignVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/27.
//

import UIKit
import RxSwift
import RxCocoa

class SignVC: UIViewController {
    
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var isEmailValidLabel: UILabel!
    @IBOutlet weak var isPasswordValidLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var findIdPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordEyeButton: UIButton!
    
    
    var disposeBag = DisposeBag()
    var signViewModel = SignVM()

    override func viewDidLoad() {
        emailView.layer.cornerRadius = 3
        passwordView.layer.cornerRadius = 3
        loginButton.layer.cornerRadius = 3
        
        bindUI()
    
        isEmailValidLabel.isHidden = true
        isPasswordValidLabel.isHidden = true
        
        emailView.layer.borderWidth = 0
        passwordView.layer.borderWidth = 0
    }
    
}

extension SignVC {
    private func bindUI() {
        // Input
        emailTextField.rx.text.orEmpty
            .bind(to: signViewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: signViewModel.passwordText)
            .disposed(by: disposeBag)
        
        passwordEyeButton.rx.tap
            .asObservable()
            .map { self.passwordEyeButton.currentImage! }
            .bind(to: signViewModel.eyeOnOff)
            .disposed(by: disposeBag)
            
        
        // Output
        let emailObs = signViewModel.isEmailVaild
                        .asObservable()
                        .share()
                        .asDriver(onErrorJustReturn: false)
        
        emailObs
            .drive(isEmailValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        emailObs
            .drive(onNext: { [weak self] email in
                self?.checkIdPasswordEnable(email, (self?.emailView)!)
            })
            .disposed(by: disposeBag)
        
        let passwordObs = signViewModel.isPasswordValid
                            .asObservable()
                            .share()
                            .asDriver(onErrorJustReturn: false)
        
        passwordObs
            .drive(isPasswordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordObs
            .drive(onNext: { [weak self] pw in
                self?.checkIdPasswordEnable(pw, (self?.passwordView)!)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(signViewModel.isEmailVaild,
                                 signViewModel.isPasswordValid) { $0 && $1 }
        .map(isEnableLoginButton)
        .bind(to: loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        signViewModel.isEyeOn
            .subscribe(onNext: { [weak self] eyeStatus in
                self?.didTapPasswordEyeButton(eyeStatus)
            })
            .disposed(by: disposeBag)
        
        // 로그인 미 구현
        loginButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                self?.loginButtonDidTap()
            })
            .disposed(by: disposeBag)
    }
}

extension SignVC {
    func isEnableLoginButton(_ flag: Bool) -> Bool {
        if flag {
            loginButton.backgroundColor = .systemPink
            return true
        } else {
            loginButton.backgroundColor = UIColor(rgb: 0x8E8E93)
            return false
        }
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
    
    func checkIdPasswordEnable(_ flag: Bool, _ idPasswordView: UIView) {
        if flag {
            idPasswordView.layer.borderWidth = 0
        } else {
            idPasswordView.layer.borderWidth = 1
            idPasswordView.layer.borderColor = UIColor.systemPink.cgColor
        }
    }
    
    func loginButtonDidTap() {
        // id, pw 암호화 작업 후 서버에 전송 
    }
}
