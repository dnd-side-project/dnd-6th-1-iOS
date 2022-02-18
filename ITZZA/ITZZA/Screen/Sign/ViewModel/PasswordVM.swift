//
//  PasswordVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/11.
//

import RxSwift
import RxCocoa

class PasswordVM {
    
    var disposeBag = DisposeBag()
    let isEqualPassword = BehaviorRelay(value: false)
    
    func comparePassword(_ pw1: String, _ pw2: String) {
        if (!pw1.isEmpty && !pw2.isEmpty) && (pw1 == pw2) {
            isEqualPassword.accept(true)
        } else {
            isEqualPassword.accept(false)
        }
    }
}
