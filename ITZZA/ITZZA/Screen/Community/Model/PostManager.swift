//
//  PostManager.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/14.
//

import Foundation

struct PostManager {
    let baseURL = "http://13.125.239.189:3000/boards"
    
    func getPost(_ apiQuery: String, _ completion: @escaping ([PostModel]?) -> ()) {
        guard let url = URL(string: baseURL + apiQuery) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImVtYWlsIjoidGVzdDFAbmF2ZXIuY29uIiwiaWF0IjoxNjQ0ODI5NjE5LCJleHAiOjE2NDY1NTc2MTl9.HCcaScltLW3aT6N-slhejlE7jmucYDbjcLjIgc6mm-I", forHTTPHeaderField: "Authorization")

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
