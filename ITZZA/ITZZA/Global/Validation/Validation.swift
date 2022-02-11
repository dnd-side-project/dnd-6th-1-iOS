//
//  Validation.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/11.
//

import RxSwift
import RxCocoa

class Validation {
    
    var disposeBag = DisposeBag()
    let emailText = BehaviorRelay(value: "")
    let passwordText = BehaviorRelay(value: "")
    let isEmailVaild = BehaviorRelay(value: false)
    let isPasswordValid = BehaviorRelay(value: false)
    let eyeOnOff = BehaviorRelay(value: UIImage())
    let isEyeOn = BehaviorRelay(value: false)
    
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
}
