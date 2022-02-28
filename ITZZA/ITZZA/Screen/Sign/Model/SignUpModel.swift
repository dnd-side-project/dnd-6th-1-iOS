//
//  SignUpModel.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/13.
//

import Alamofire

struct SignUpModel {
    let email: String
    let password: String
    let nickname: String
}

extension SignUpModel {
    var signUpParam: Parameters {
        return [
            "email": email,
            "password": password,
            "nickname": nickname
        ]
    }
}

struct SignUpResponse: Decodable {
    var data: DataResponse?
    var message: String?
}

struct DataResponse: Decodable {
    var email: String?
    var password: String?
    var nickname: String?
    var profileImage: String?
    var userId: Int?
    var userStatus: Bool?
    var loginStatus: Bool?
}
