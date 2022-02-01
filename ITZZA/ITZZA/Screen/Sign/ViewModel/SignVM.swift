//
//  SignVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/27.
//

import RxSwift
import RxCocoa
import RxDataSources

class SignVM {
    
    var disposeBag = DisposeBag()
    
    let emailText = BehaviorRelay(value: "")
    let passwordText = BehaviorRelay(value: "")
    
    let isEmailVaild = BehaviorRelay(value: false)
    let isPasswordValid = BehaviorRelay(value: false)
    
    let eyeOnOff = BehaviorRelay(value: UIImage())
    let isEyeOn = BehaviorRelay(value: false)
    
    let emailPassword = (email: "", password: "")
    
    let apiSession = APISession()
    var onError = PublishSubject<APIError>()
    var loginResponseFail = PublishSubject<String>()
    var loginResponseSuccess = PublishSubject<String>()
    
    init () {
        _ = emailText.distinctUntilChanged()
            .map(checkEmailVaild)
            .bind(to: isEmailVaild)
        
        _ = passwordText.distinctUntilChanged()
            .map(checkPasswordVaild)
            .bind(to: isPasswordValid)
        
        _ = eyeOnOff
            .map(checkEyeOn)
            .bind(to: isEyeOn)
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
                        self.loginResponseFail.onNext(response.flag)
                    } else {
                        self.loginResponseSuccess.onNext(response.flag)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

}
