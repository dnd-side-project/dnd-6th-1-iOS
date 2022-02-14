//
//  SignModel.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/30.
//

import Alamofire

struct SignInModel {
    let email: String
    let password: String
}

extension SignInModel {
    var loginParam: Parameters {
        return ["email": email,
                "password": password]
    }
}

struct SignInResponse: Decodable {
    let flag: Int?
}
