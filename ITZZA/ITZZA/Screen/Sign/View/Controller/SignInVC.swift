//
//  SignVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/27.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var isEmailValidLabel: UILabel!
    @IBOutlet weak var isPasswordValidLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var findIdPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordEyeButton: UIButton!
    @IBOutlet weak var signInIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var saveSignInStateButton: UIButton!
    
    var disposeBag = DisposeBag()
    var signInViewModel = SignInVM()

    override func viewDidLoad() {
        bindUI()
        setInitialUIValue()
        didTapSignInButton()
        signInOnSessionError()
        signInResponseFail()
        signInResponseSuccess()
        changeSaveSignInStatusButton()
    }
    
}

// MARK: - Binding Methods
extension SignInVC {
    private func bindUI() {
        emailTextField.rx.text.orEmpty
            .bind(to: signInViewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: signInViewModel.passwordText)
            .disposed(by: disposeBag)
        
        passwordEyeButton.rx.tap
            .asObservable()
            .map { [weak self] in
                (self?.passwordEyeButton.currentImage)!
            }
            .bind(to: signInViewModel.eyeOnOff)
            .disposed(by: disposeBag)
        
        signInViewModel.indicatorController.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.stopActivityIndicator()
            })
            .disposed(by: disposeBag)
       
        let emailValidObservable = signInViewModel.isEmailVaild
                        .asObservable()
                        .share()
                        .asDriver(onErrorJustReturn: false)
        
        emailValidObservable
            .drive(isEmailValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        emailValidObservable
            .drive(onNext: { [weak self] email in
                self?.checkIdPasswordEnable(email, (self?.emailView)!)
            })
            .disposed(by: disposeBag)
        
        let passwordValidObservable = signInViewModel.isPasswordValid
                            .asObservable()
                            .share()
                            .asDriver(onErrorJustReturn: false)
        
        passwordValidObservable
            .drive(isPasswordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValidObservable
            .drive(onNext: { [weak self] pw in
                self?.checkIdPasswordEnable(pw, (self?.passwordView)!)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(signInViewModel.isEmailVaild,
                                 signInViewModel.isPasswordValid) {
            $0 && $1
        }
        .map(changeSignInButton)
        .bind(to: signInButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        signInViewModel.isEyeOn
            .subscribe(onNext: { [weak self] eyeStatus in
                self?.didTapPasswordEyeButton(eyeStatus)
            })
            .disposed(by: disposeBag)
        
        signInViewModel.isSignInStateSelected.asDriver()
            .drive(onNext: { [weak self] selected in
                guard let self = self else { return }
                self.didTapSaveSignInStatusButton(selected)
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.showSignUpVC()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Save SignIn Method
extension SignInVC {
    func changeSaveSignInStatusButton() {
        saveSignInStateButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.signInViewModel.changeSaveSignInStatus()
            })
            .disposed(by: disposeBag)
    }
    
    func didTapSaveSignInStatusButton(_ selected: Bool) {
        if selected {
            saveSignInStateButton.setImage(UIImage(named: "SaveSignInStatusFill"), for: .normal)
        } else {
            saveSignInStateButton.setImage(UIImage(named: "SaveSignInStatusOutline"), for: .normal)
        }
    }
}

// MARK: - Email, Password UI
extension SignInVC {
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
}

// MARK: - Sign In Methods
extension SignInVC {
    func didTapSignInButton() {
        let emailObservable = emailTextField.rx.text.orEmpty
        let passwordObservable = passwordTextField.rx.text.orEmpty
        let combinedEmailPassword = Observable.combineLatest(emailObservable, passwordObservable)
        
        signInButton.rx.tap
            .withLatestFrom(combinedEmailPassword)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.signInIndicatorView.isHidden = false
                self.signInIndicatorView.startAnimating()
                self.signInViewModel.tapSignInButton($0, $1)
            })
            .disposed(by: disposeBag)
    }
    
    func signInOnSessionError() {
        signInViewModel.onError.asDriver(onErrorJustReturn: .unknown)
            .drive { [weak self] error in
                guard let self = self else { return }
                self.showSignInErrorAlert(error.description)
            }
            .disposed(by: disposeBag)
    }
    
    func signInResponseFail() {
        signInViewModel.signInResponseFail.asDriver(onErrorJustReturn: "0")
            .drive { [weak self] response in
                guard let self = self else { return }
                self.showSignInErrorAlert(response)
            }
            .disposed(by: disposeBag)
    }
    
    func signInResponseSuccess() {
        signInViewModel.signInResponseSuccess.asDriver(onErrorJustReturn: "1")
            .drive { [weak self] response in
                guard let self = self else { return }
                let tabBarVC = ViewControllerFactory.viewController(for: .tabBar)
                tabBarVC.modalPresentationStyle = .fullScreen
                
                self.view.window?.rootViewController?.dismiss(animated: false) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.email = self.emailTextField.text
                    appDelegate.password = self.passwordTextField.text
                    appDelegate.window?.rootViewController?.present(tabBarVC, animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func changeSignInButton(_ flag: Bool) -> Bool {
        if flag {
            signInButton.backgroundColor = .systemPink
            return true
        } else {
            signInButton.backgroundColor = UIColor.signInButtonBackgroundColor
            return false
        }
    }
    
}

// MARK: - Change View Controller
extension SignInVC {
    func showSignUpVC() {
        let signUpVC = ViewControllerFactory.viewController(for: .signUp) as! SignUpVC
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true, completion: nil)
    }
}

// MARK: - Indicator
extension SignInVC {
    func stopActivityIndicator() {
        signInIndicatorView.stopAnimating()
    }
}

// MARK: - Set Initial UI Value
extension SignInVC {
    func setInitialUIValue() {
        emailView.layer.cornerRadius = 3
        passwordView.layer.cornerRadius = 3
        signInButton.layer.cornerRadius = 3
        isEmailValidLabel.isHidden = true
        isPasswordValidLabel.isHidden = true
        emailView.layer.borderWidth = 0
        passwordView.layer.borderWidth = 0
        saveSignInStateButton.isSelected = false
        saveSignInStateButton.layer.cornerRadius = 20
        signInIndicatorView.isHidden = true
    }
}
