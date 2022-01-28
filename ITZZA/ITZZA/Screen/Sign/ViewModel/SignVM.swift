//
//  SignVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/27.
//

import RxSwift
import RxCocoa

class SignVM {
    
    let emailText = BehaviorSubject(value: "")
    let passwordText = BehaviorSubject(value: "")
    
    let isEmailVaild = BehaviorSubject(value: false)
    let isPasswordValid = BehaviorSubject(value: false)
    
    let eyeOnOff = BehaviorSubject(value: UIImage())
    let isEyeOn = BehaviorSubject(value: false)
    
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
    
}
