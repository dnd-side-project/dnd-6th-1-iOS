//
//  APISession.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/30.
//

import Alamofire
import RxSwift
import SwiftKeychainWrapper

struct urlResource<T: Decodable> {
    let url: URL
}

struct APISession: APIService {
    
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters) -> Observable<Result<T, APIError>> {
        
        Observable<Result<T, APIError>>.create { observer in
            let header: HTTPHeaders = ["Content-Type": "application/json"]
            
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
    
    func getRequest<T>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>> where T : Decodable {
        
        return Observable<Result<T, APIError>>.create { observer in
            
            guard let token: String = KeychainWrapper.standard[.myToken] else { return Disposables.create { } }
            
            let header: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]
            
            let task = AF.request(urlResource.url, headers: header)
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
    
    func postRequestWithImages<T: Decodable>(with urlResource: urlResource<T>, param: Parameters, images: [UIImage], method: HTTPMethod) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            guard let token: String = KeychainWrapper.standard[.myToken] else { return Disposables.create{} }
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "multipart/form-data"
            ]
            
            let task = AF.upload(multipartFormData: { (multipart) in
                for (key, value) in param {
                    multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                }
                images.forEach { image in
                    if let imageData = image.jpegData(compressionQuality: 1) {
                        multipart.append(imageData, withName: "files", fileName: "image.png", mimeType: "image/png")
                    }
                }
            }, to: urlResource.url, method: method, headers: headers)
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
    
    func deleteRequest<T: Decodable>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>> where T : Decodable {
        
        return Observable<Result<T, APIError>>.create { observer in
            
            guard let token: String = KeychainWrapper.standard[.myToken] else { return Disposables.create { } }
            
            let header: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]
            
            let task = AF.request(urlResource.url, method: .delete, headers: header)
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
