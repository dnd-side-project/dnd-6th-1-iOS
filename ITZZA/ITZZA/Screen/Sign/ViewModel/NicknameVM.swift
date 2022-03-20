//
//  NicknameVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/11.
//

import RxSwift
import RxCocoa
import Foundation

class NicknameVM {
    
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    let nicknameTextField = BehaviorRelay(value: "")
    let emptyTextField = BehaviorRelay(value: false)
    let duplicateNickname = BehaviorRelay(value: false)
    let availableNickname = BehaviorRelay(value: false)
    let serverError = BehaviorRelay(value: false)
    
    init() {
        nicknameTextField
            .distinctUntilChanged()
            .withUnretained(self)
            .map { owner, str in
                owner.checkTextLength(str)
            }
            .bind(to: emptyTextField)
            .disposed(by: disposeBag)
    }
    
    private func checkTextLength(_ text: String) -> Bool {
        if text.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func tapCheckDuplicateButton(with nickname: String?) {
        guard let nickname = nickname else { return }
        
        let baseURL = "https://www.itzza.shop/auth/signup/\(nickname)"
        let encodedURL = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedURL)!
        let resource = urlResource<NicknameResponse>(url: url)
        
        apiSession.signUpGetRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    switch error {
                    case .http(_):
                        owner.duplicateNickname.accept(true)
                    case .unknown:
                        owner.serverError.accept(false)
                    default:
                        owner.serverError.accept(false)
                    }
                    
                case .success(_):
                    owner.availableNickname.accept(true)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
