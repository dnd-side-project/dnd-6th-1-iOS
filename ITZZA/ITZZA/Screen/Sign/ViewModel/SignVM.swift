//
//  SignVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/27.
//

import RxSwift
import RxCocoa

class SignVM {
    
    let emailText = BehaviorRelay(value: "")
    let passwordText = BehaviorRelay(value: "")
    
    let isEmailVaild = BehaviorRelay(value: false)
    let isPasswordValid = BehaviorRelay(value: false)
    
    let eyeOnOff = BehaviorRelay(value: UIImage())
    let isEyeOn = BehaviorRelay(value: false)
    
    let emailPassword = (email: "", password: "")
    
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
        // 로그인 API 서버로부터 데이터 주고 받기
        // success -> 홈 화면 이동
        // fail -> 로그인 실패 알림 
    }
    
}
