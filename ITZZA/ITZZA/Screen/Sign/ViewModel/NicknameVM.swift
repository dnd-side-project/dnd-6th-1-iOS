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
    
        let nicknameURL = "https://3044b01e-b59d-4905-a40d-1bef340f11ab.mock.pstmn.io/v1/nickname"
        let url = URL(string: nicknameURL)!
        let nicknameModel = NicknameModel(nickname: nickname)
        let nicknameParameter = nicknameModel.nicknameParam
        let resource = urlResource<NicknameResponse>(url: url)
        
        apiSession.postRequest(with: resource, param: nicknameParameter)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(_):
                    owner.serverError.accept(false)
                case .success(let response):
                    if response.flag == 1 {
                        owner.availableNickname.accept(true)
                    } else {
                        owner.duplicateNickname.accept(false)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
}
