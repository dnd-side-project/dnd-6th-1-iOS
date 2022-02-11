//
//  NicknameVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/11.
//

import RxSwift
import RxCocoa

class NicknameVM {
    
    var disposeBag = DisposeBag()
    let nicknameText = PublishSubject<String>()
    
    func tapCheckDuplicateButton(with nickname: String?) {
        if nickname == "" {
            return
        }
        print("Loading...")
    }
    
}
