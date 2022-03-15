//
//  WithdrawalVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/03/15.
//

import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class WithdrawalVM {
    
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    let apiError = PublishSubject<Void>()
    let withdrawalSuccess = PublishSubject<Void>()
    
    func tryWithdrawal() {
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        
        let baseURL = "https://www.itzza.shop/users/\(userId)"
        let url = URL(string: baseURL)!
        let resource = urlResource<SignOutModel>(url: url)
        
        apiSession.deleteRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(_):
                    owner.apiError.onNext(())
                    
                case .success(_):
                    owner.withdrawalSuccess.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
    
}
