//
//  APISession.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/30.
//

import Alamofire
import Foundation
import RxSwift

struct APISession: APIService {
    func signInRequest(with url: URL, info: SignInModel) -> Observable<Result<SignInResponse, APIError>> {
        
        Observable<Result<SignInResponse, APIError>>.create { observer in
            
            let header : HTTPHeaders = ["Content-Type": "application/json"]
            let task = AF.request(url, method: .post,
                                  parameters: info.loginParam,
                                  encoding: JSONEncoding.default,
                                  headers: header)
                .validate(statusCode: 200...399)
                .responseDecodable(of: SignInResponse.self) { response in
                    
                    switch response.result {
                    case .failure(let error):
                        print("Unknown HTTP Response Error!!!: \(error.localizedDescription)")
                        observer.onNext(.failure(.unknown))
                        
                    case .success(let decodedData):
                        observer.onNext(.success(decodedData))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
