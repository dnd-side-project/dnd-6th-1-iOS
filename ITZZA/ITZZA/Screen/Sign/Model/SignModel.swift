//
//  SignModel.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/30.
//

import Foundation
import Alamofire

struct LoginModel {
    let email: String
    let password: String
}

extension LoginModel {
    var loginParam: Parameters {
        return ["email": email,
                "password": password]
    }
}

struct LoginResponse: Decodable {
    let flag: String
}

/// email
/// password
/// nickname
///
/// success: 1
/// 회원가입 성공 메시지 서버에서 보내줄 예정
///
/// fail: 0
/// error message(중복 닉네임인지, 중복 이메일인지)를 서버에서 보내줄 예정
