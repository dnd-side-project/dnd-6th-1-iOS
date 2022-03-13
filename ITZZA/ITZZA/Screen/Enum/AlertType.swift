//
//  AlertType.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/13.
//

import Foundation

enum AlertType {
    case signInError
    case signUpError
    case networkError
    case deletedPost
    
    var title: String {
        switch self {
        case .signInError:
            return "로그인에 실패했습니다."
        case .signUpError:
            return "회원가입에 실패했습니다."
        case .networkError:
            return "네트워크 오류"
        case .deletedPost:
            return "삭제된 게시글입니다"
        }
    }
}
