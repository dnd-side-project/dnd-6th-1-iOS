//
//  FindPasswordVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/03/15.
//

import RxSwift
import RxCocoa

class FindPasswordVM {
    
    var disposeBag = DisposeBag()
    let apiSesson = APISession()
    let sendEmailSuccess = PublishSubject<Void>()
    let sendEmailFail = PublishSubject<Void>()
    
    func sendEmail(_ email: String) {
        let baseURL = "http://3.36.71.216:3000/auth/signin/\(email)"
        let url = URL(string: baseURL)!
        let resource = urlResource<FindPasswordModel>(url: url)
        
        apiSesson.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(_):
                    owner.sendEmailFail.onNext(())
                    
                case .success(_):
                    owner.sendEmailSuccess.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
}
