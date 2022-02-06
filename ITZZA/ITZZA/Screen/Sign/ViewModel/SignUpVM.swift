//
//  SignUpVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/04.
//

import RxSwift
import RxCocoa

class SignUpVM {
    
    var disposeBag = DisposeBag()
    let pageCount = BehaviorRelay(value: 0)
    let previousButtonTitle = BehaviorRelay(value: "메인으로")
    let goToMain = BehaviorRelay(value: false)
    
    func increasePageCount() {
        let num = pageCount.value + 1
        changeButtonTitle(num)
        pageCount.accept(num)
    }
    
    func decreasePageCount() {
        let num = pageCount.value - 1
        changeButtonTitle(num)
        pageCount.accept(num)
    }
    
    func changeButtonTitle(_ num: Int) {
        if num == 0 {
            previousButtonTitle.accept("메인으로")
        } else {
            previousButtonTitle.accept("이전단계")
        }
    }
    
    func checkGoToMain() {
        if pageCount.value == -1 {
            goToMain.accept(true)
        }
    }
}
