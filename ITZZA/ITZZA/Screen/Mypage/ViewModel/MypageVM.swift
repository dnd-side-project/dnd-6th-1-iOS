//
//  MypageVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/26.
//

import RxSwift
import RxCocoa
import SwiftKeychainWrapper
import Alamofire

class MypageVM {
    
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    let apiError = PublishSubject<APIError>()
    let getMypageSuccess = PublishSubject<MypageModel>()
        
}

// MARK: - Networking
extension MypageVM {
    func getUserInformation() {
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        
        let baseURL = "http://13.125.239.189:3000/users/\(userId)"
        let url = URL(string: baseURL)!
        let resource = urlResource<MypageModel>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    
                case .success(let response):
                    owner.getMypageSuccess.onNext(response)
                }
            })
            .disposed(by: disposeBag)
        
    }
}
