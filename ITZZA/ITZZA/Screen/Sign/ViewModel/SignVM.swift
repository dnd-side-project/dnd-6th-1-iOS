//
//  SignVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/27.
//

import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class SignVM {
    
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    
    let emailText = BehaviorRelay(value: "")
    let passwordText = BehaviorRelay(value: "")
    
    let isEmailVaild = BehaviorRelay(value: false)
    let isPasswordValid = BehaviorRelay(value: false)
    
    let eyeOnOff = BehaviorRelay(value: UIImage())
    let isEyeOn = BehaviorRelay(value: false)
    
    let emailPassword = (email: "", password: "")

    let onError = PublishSubject<APIError>()
    let loginResponseFail = PublishSubject<String>()
    let loginResponseSuccess = PublishSubject<String>()
    let isLoading = BehaviorRelay(value: true)
    
    let savedStatus = BehaviorRelay(value: false)
    let savedEmail = PublishSubject<String>()
    let savedPassword = PublishSubject<String>()
    let isLoginStateSelected = BehaviorRelay(value: false)
    
    init () {
        emailText.distinctUntilChanged()
            .map(checkEmailVaild)
            .bind(to: isEmailVaild)
            .disposed(by: disposeBag)
        
        passwordText.distinctUntilChanged()
            .map(checkPasswordVaild)
            .bind(to: isPasswordValid)
            .disposed(by: disposeBag)
        
        eyeOnOff
            .map(checkEyeOn)
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
    
    func changeSaveLoginStatus() {
        isLoginStateSelected.accept(!isLoginStateSelected.value)
    }
    
    // AppDelegate
//    func checkSavedLoginData() {
//        guard let userEmail = UserDefaults.standard.string(forKey: "email"),
//            let userPassword = KeychainWrapper.standard.string(forKey: userEmail) else {
//                print("no")
//                savedStatus.accept(false)
//                return
//        }
//        print("yes")
//        savedStatus.accept(true)
//        savedEmail.onNext(userEmail)
//        savedPassword.onNext(userPassword)
////        loginWithSavedData(with: userEmail, userPassword)
//
////        if let userEmail = UserDefaults.standard.string(forKey: "email") {
////            let userPassword = KeychainWrapper.standard.string(forKey: userEmail) ?? "00000000"
////            loginWithSavedData(with: userEmail, userPassword)
////        } else {
////            print("No data")
////        }
//    }
//
//    // AppDelegate
//    func loginWithSavedData(with email: String, _ password: String) {
//        tapLoginButton(email, password)
//    }
    
    func tapLoginButton(_ email: String, _ password: String) {
        
        let loginURL = "https://3044b01e-b59d-4905-a40d-1bef340f11ab.mock.pstmn.io/v1/login"
        let url = URL(string: loginURL)!
        let loginInformation = LoginModel(email: email, password: password)
        
        apiSession
            .loginRequest(with: url, info: loginInformation)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.onError.onNext(error)
                    
                case .success(let response):
                    if response.flag == "0" {
                        self.loginResponseFail.onNext("로그인 정보가 잘못되었습니다")
                    } else {
                        if self.isLoginStateSelected.value {
                            print("data save")
                            self.saveUserData(email, password)
                        }
                        self.loginResponseSuccess.onNext(response.flag)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func saveUserData(_ email: String, _ password: String) {
        UserDefaults.standard.set(email, forKey: "email")
        KeychainWrapper.standard.set(password, forKey: email)
    }

}
