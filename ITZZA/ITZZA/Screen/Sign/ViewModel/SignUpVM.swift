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
    let decideProgressBarColor = BehaviorRelay(value: UIColor.orange)

    let visualizeAngryImage = BehaviorRelay(value: false)
    let visualizeConfuseImage = BehaviorRelay(value: true)
    let visualizeSadImage = BehaviorRelay(value: true)
    let visualizeComfyImage = BehaviorRelay(value: true)
    var checker: BehaviorRelay<Bool>?

    init() {
        checker = visualizeAngryImage
    }
    
    func increasePageCount() {
        let num = pageCount.value + 1
        changeButtonTitle(num)
        pageCount.accept(num)
        changeProgressBarColor()
        ignoreUntilChange()
    }
    
    func decreasePageCount() {
        let num = pageCount.value - 1
        changeButtonTitle(num)
        pageCount.accept(num)
        changeProgressBarColor()
        ignoreUntilChange()
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
    
    func changeProgressBarColor() {
        switch pageCount.value {
        case 0:
            decideProgressBarColor.accept(UIColor.orange)
        case 1:
            decideProgressBarColor.accept(UIColor.purple)
        case 2:
            decideProgressBarColor.accept(UIColor.blue)
        case 3:
            decideProgressBarColor.accept(UIColor.yellow)
        default:
            decideProgressBarColor.accept(UIColor.orange)
        }
    }
    
    func ignoreUntilChange() {
        switch pageCount.value {
        case 0:
            checker?.accept(true)
            checker = visualizeAngryImage
            visualizeAngryImage.accept(false)
        case 1:
            checker?.accept(true)
            checker = visualizeConfuseImage
            visualizeConfuseImage.accept(false)
        case 2:
            checker?.accept(true)
            checker = visualizeSadImage
            visualizeSadImage.accept(false)
        case 3:
            checker?.accept(true)
            checker = visualizeComfyImage
            visualizeComfyImage.accept(false)
        default:
            checker?.accept(true)
            checker = visualizeAngryImage
            visualizeAngryImage.accept(false)
        }
    }
}
