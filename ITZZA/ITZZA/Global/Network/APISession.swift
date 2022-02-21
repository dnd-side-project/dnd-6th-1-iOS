//
//  APISession.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/30.
//

import Alamofire
import RxSwift

struct urlResource<T: Decodable> {
    let url: URL
}

struct APISession: APIService {
    
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters) -> Observable<Result<T, APIError>> {

        Observable<Result<T, APIError>>.create { observer in
             let header: HTTPHeaders = ["Content-Type": "application/json"]
            
            // postman mock server 사용을 위한 임시 헤더, 위에 헤더로 바꿔야할 것
//            let header: HTTPHeaders = ["x-mock-match-request-body": "true"]
            let task = AF.request(urlResource.url,
                                  method: .post,
                                  parameters: param,
                                  encoding: JSONEncoding.default,
                                  headers: header)
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
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
