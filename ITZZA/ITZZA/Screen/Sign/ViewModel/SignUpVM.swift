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
    let apiSession = APISession()
    let pageCount = BehaviorRelay(value: 0)
    let previousButtonTitle = BehaviorRelay(value: "메인으로")
    let goToMain = BehaviorRelay(value: false)
    let decideProgressBarColor = BehaviorRelay(value: UIColor.orange)
    let visualizeAngryImage = BehaviorRelay(value: false)
    let visualizeConfuseImage = BehaviorRelay(value: true)
    let visualizeSadImage = BehaviorRelay(value: true)
    let visualizeComfyImage = BehaviorRelay(value: true)
    var checker: BehaviorRelay<Bool>?
    let serverError = PublishSubject<APIError>()
    let signUpSuccess = PublishSubject<String>()
    let signUpFail = PublishSubject<String>()

    init() {
        checker = visualizeAngryImage
    }
    
    func increasePageCount() {
        if pageCount.value < 3 {
            let num = pageCount.value + 1
            changeButtonTitle(num)
            pageCount.accept(num)
            changeProgressBarColor()
            ignoreUntilChange()
        }
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
    
    private func changeProgressBarColor() {
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
    
    private func ignoreUntilChange() {
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

// MARK: - Networking
extension SignUpVM {
    func trySignUp(with email: String, _ password: String, _ nickname: String) {
        let signUpURL = "https://3044b01e-b59d-4905-a40d-1bef340f11ab.mock.pstmn.io/v1/signup"
        let url = URL(string: signUpURL)!
        let signUpModel = SignUpModel(email: email, password: password, nickname: nickname)
        let signUpParameter = signUpModel.signUpParam
        let resource = urlResource<SignUpResponse>(url: url)
        
        apiSession
            .postRequest(with: resource, param: signUpParameter)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.serverError.onNext(error)
                    
                case .success(let response):
                    if response.flag == 1 {
                        owner.signUpSuccess.onNext("회원가입이 완료되었습니다")
                    } else {
                        owner.signUpFail.onNext("닉네임 중복확인을 다시 한 번 해주세요")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
