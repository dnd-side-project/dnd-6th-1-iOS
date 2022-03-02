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
    let eyeOnOff = BehaviorRelay(value: false)
    let isEyeOn = PublishRelay<Bool>()
    
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
    }
    
    private func checkEmailVaild(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func checkPasswordVaild(_ password: String) -> Bool {
        return password.count >= 8
    }

    func checkEyeOn(_ eyeStatus: Bool) {
        if eyeStatus {
            isEyeOn.accept(true)
        }
        else {
            isEyeOn.accept(false)
        }
    }
}
