//
//  PostManager.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/14.
//

import Foundation
import SwiftKeychainWrapper

struct PostManager {
    let baseURL = "http://13.125.239.189:3000/boards"
    
    func getPost(_ apiQuery: String, _ completion: @escaping ([PostModel]?) -> ()) {
        guard let url = URL(string: baseURL + apiQuery) else { return }
        guard let token: String = KeychainWrapper.standard[.myToken] else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(nil)
            } else if let data = data {
                let posts = try? JSONDecoder().decode([PostModel].self, from: data)
                
                if let posts = posts {
                    completion(posts)
                }                
            }
        }.resume()
    }
}
