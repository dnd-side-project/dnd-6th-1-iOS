//
//  PostManager.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/14.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire

struct PostManager {
    let baseURL = "https://www.itzza.shop/boards"
    
    func getPost(_ apiQuery: String, _ completion: @escaping ([PostModel]?) -> ()) {
        guard let url = URL(string: baseURL + apiQuery) else { return }
        guard let token: String = KeychainWrapper.standard[.myToken] else { return }
        let header: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200...399)
            .responseDecodable(of: [PostModel].self) { response in
            switch response.result {
            case .success(let decodedPost):
                completion(decodedPost)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func getPostDetail(_ boardId: Int, _ completion: @escaping (PostModel?) -> ()) {
        guard let url = URL(string: baseURL + "/\(boardId)") else { return }
        guard let token: String = KeychainWrapper.standard[.myToken] else { return }
        let header: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200...399)
            .responseDecodable(of: PostModel.self) { response in
            switch response.result {
            case .success(let decodedPost):
                completion(decodedPost)
            case .failure:
                completion(nil)
            }
        }
    }
}
