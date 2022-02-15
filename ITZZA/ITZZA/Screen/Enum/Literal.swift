//
//  Literal.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/11.
//

import Foundation

enum Literal {
    case email
    case password
    case nickname
    case agreement
    case first
    case second
    case third
    case fourth
}

extension Literal {
    var description: String {
        switch self {
        case .email:
            return "이메일 입력"
        case .password:
            return "비밀번호 입력"
        case .nickname:
            return "닉네임 입력"
        case .agreement:
            return "약관 동의"
        case .first:
            return "시작이 반이다!"
        case.second:
            return "벌써 2단계!"
        case .third:
            return "거의 다 왔어요!"
        case .fourth:
            return "이제 마지막!"
        }
    }
}
