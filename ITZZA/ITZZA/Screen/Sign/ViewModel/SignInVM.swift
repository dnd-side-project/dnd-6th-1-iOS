//
//  SignVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/27.
//

import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class SignInVM {
    
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    
    let onError = PublishSubject<APIError>()
    let signInResponseFail = PublishSubject<String>()
    let signInResponseSuccess = PublishSubject<Int>()
    let indicatorController = BehaviorRelay(value: false)
    
    let savedStatus = BehaviorRelay(value: false)
    let savedEmail = PublishSubject<String>()
    let savedPassword = PublishSubject<String>()
    let isSignInStateSelected = BehaviorRelay(value: false)
    
    func changeSaveSignInStatus() {
        isSignInStateSelected.accept(!isSignInStateSelected.value)
    }
    
    func tapSignInButton(_ email: String, _ password: String) {
        
        let loginURL = "https://3044b01e-b59d-4905-a40d-1bef340f11ab.mock.pstmn.io/v1/login"
        let url = URL(string: loginURL)!
        let signInformation = SignInModel(email: email, password: password)
        let signInParameter = signInformation.loginParam
        let resource = urlResource<SignInResponse>(url: url)
        
        apiSession.postRequest(with: resource, param: signInParameter)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.onError.onNext(error)
                    
                case .success(let response):
                    guard let flag = response.flag,
                          let accessToken = response.accessToken
                    else { return }
                    
                    if flag == 0 {
                        owner.signInResponseFail.onNext("로그인 정보가 잘못되었습니다")
                    } else {
                        if owner.isSignInStateSelected.value {
                            owner.saveUserData(email, password, accessToken)
                        }
                        owner.signInResponseSuccess.onNext(flag)
                    }
                }
                owner.indicatorController.accept(true)
            })
            .disposed(by: disposeBag)
    }
    
    func saveUserData(_ email: String, _ password: String, _ token: String) {
        UserDefaults.standard.set(email, forKey: "email")
        KeychainWrapper.standard[.myPassword] = password
        KeychainWrapper.standard[.myToken] = token
    }

}
