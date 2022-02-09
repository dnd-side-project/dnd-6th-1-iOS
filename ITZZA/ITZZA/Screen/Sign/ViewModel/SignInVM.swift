//
//  SignVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/27.
//

import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class SignInVM {
    
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    
    let emailText = BehaviorRelay(value: "")
    let passwordText = BehaviorRelay(value: "")
    
    let isEmailVaild = BehaviorRelay(value: false)
    let isPasswordValid = BehaviorRelay(value: false)
    
    let eyeOnOff = BehaviorRelay(value: UIImage())
    let isEyeOn = BehaviorRelay(value: false)

    let onError = PublishSubject<APIError>()
    let signInResponseFail = PublishSubject<String>()
    let signInResponseSuccess = PublishSubject<String>()
    let indicatorController = BehaviorRelay(value: false)
    
    let savedStatus = BehaviorRelay(value: false)
    let savedEmail = PublishSubject<String>()
    let savedPassword = PublishSubject<String>()
    let isSignInStateSelected = BehaviorRelay(value: false)
    
    init () {
        emailText.distinctUntilChanged()
            .withUnretained(self)
            .map { owner, str in
                owner.checkEmailVaild(str)
            }
            .bind(to: isEmailVaild)
            .disposed(by: disposeBag)
        
        passwordText.distinctUntilChanged()
            .withUnretained(self)
            .map { owner, str in
                owner.checkPasswordVaild(str)
            }
            .bind(to: isPasswordValid)
            .disposed(by: disposeBag)
        
        eyeOnOff
            .withUnretained(self)
            .map { owner, img in
                owner.checkEyeOn(img)
            }
            .bind(to: isEyeOn)
            .disposed(by: disposeBag)
    }
    
    private func checkEmailVaild(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func checkPasswordVaild(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    private func checkEyeOn(_ eyeStatus: UIImage) -> Bool {
        if eyeStatus.isEqual(UIImage(named: "PasswordEyeOn")) {
            return true
        }
        else {
            return false
        }
    }
    
    func changeSaveSignInStatus() {
        isSignInStateSelected.accept(!isSignInStateSelected.value)
    }
    
    func tapSignInButton(_ email: String, _ password: String) {
        
        let loginURL = "https://3044b01e-b59d-4905-a40d-1bef340f11ab.mock.pstmn.io/v1/login"
        let url = URL(string: loginURL)!
        let loginInformation = SignInModel(email: email, password: password)
        
        apiSession
            .signInRequest(with: url, info: loginInformation)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.onError.onNext(error)
                    
                case .success(let response):
                    if response.flag == "0" {
                        self.signInResponseFail.onNext("로그인 정보가 잘못되었습니다")
                    } else {
                        if self.isSignInStateSelected.value {
                            self.saveUserData(email, password)
                        }
                        self.signInResponseSuccess.onNext(response.flag)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func saveUserData(_ email: String, _ password: String) {
        UserDefaults.standard.set(email, forKey: "email")
        KeychainWrapper.standard[.myKey] = password
    }

}
