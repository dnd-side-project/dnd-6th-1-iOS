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
        
        let loginURL = "http://13.125.239.189:3000/auth/signin"
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
                          let accessToken = response.accessToken,
                          let userId = response.userId
                    else { return }
                    
                    if flag == 0 {
                        owner.signInResponseFail.onNext("로그인 정보가 잘못되었습니다")
                    } else {
                        if owner.isSignInStateSelected.value {
                            owner.saveUserDataToKeychain(email, password, accessToken, userId)
                        } else {
                            owner.saveUserDataToSingleton(accessToken, userId)
                        }
                        owner.signInResponseSuccess.onNext(flag)
                    }
                }
                owner.indicatorController.accept(true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Save Login Informations
extension SignInVM {
    
    private func saveUserDataToKeychain(_ email: String, _ password: String, _ token: String, _ userId: Int) {
        UserDefaults.standard.set(email, forKey: "email")
        KeychainWrapper.standard[.myPassword] = password
        KeychainWrapper.standard[.myToken] = token
        KeychainWrapper.standard[.userId] = userId
    }
    
    private func saveUserDataToSingleton(_ token: String, _ userId: Int) {
        let userInformation = UserInformation.shared
        userInformation.token = token
        userInformation.userId = userId
    }
}
