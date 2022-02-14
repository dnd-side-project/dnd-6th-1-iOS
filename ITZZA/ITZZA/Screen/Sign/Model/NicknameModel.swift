//
//  NicknameModel.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/11.
//

import Alamofire

struct NicknameModel {
    let nickname: String
}

extension NicknameModel {
    var nicknameParam: Parameters {
        return ["nickname": nickname]
    }
}

struct NicknameResponse: Decodable {
    let flag: Int?
}
