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
    let signOutSuccess = PublishSubject<Void>()
    var myInfo = MypageModel()
        
}

// MARK: - Networking
extension MypageVM {
    func getUserInformation() {
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        
        let baseURL = "http://3.36.71.216:3000/users/\(userId)"
        let url = URL(string: baseURL)!
        let resource = urlResource<MypageModel>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    
                case .success(let response):
                    owner.myInfo = response
                    owner.getMypageSuccess.onNext(response)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func signOut() {
        let baseURL = "http://3.36.71.216:3000/auth/signout"
        let url = URL(string: baseURL)!
        let resource = urlResource<SignOutModel>(url: url)
        
        apiSession.patchRequest(with: resource, param: Parameters())
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    
                case .success(_):
                    owner.removeUserData()
                    owner.signOutSuccess.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
    
    func removeUserData() {
        UserDefaults.standard.removeObject(forKey: "email")
        KeychainWrapper.standard.removeAllKeys()
    }
}
