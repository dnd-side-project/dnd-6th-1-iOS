//
//  ToastType.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/02.
//

import Foundation

enum ToastType {
    case postPost
    case postDeleted
    case commentPost
    case commentDeleted
    case shouldPostDelete
    case shouldCommentDelete
    case postEdit
    case commentEdit
    case reportSaved
    case signUp
    case signOut
    case withdrawal
    case findPassword
    
    var message: String {
        switch self {
        case .postPost:
            return "게시글이 업로드 되었습니다"
        case .postDeleted:
            return "게시글이 삭제되었습니다"
        case .commentPost:
            return "댓글이 등록되었습니다"
        case .commentDeleted:
            return "댓글이 삭제되었습니다"
        case .shouldPostDelete:
            return "게시글을 정말 삭제하시겠습니까?"
        case .shouldCommentDelete:
            return "댓글을 정말 삭제하시겠습니까?"
        case .postEdit:
            return "게시글 수정이 완료되었습니다"
        case .commentEdit:
            return "댓글 수정이 완료되었습니다"
        case .reportSaved:
            return "리포트가 저장되었습니다"
        case .signUp:
            return "회원가입이 완료되었습니다"
        case .signOut:
            return "로그아웃이 완료되었습니다"
        case .withdrawal:
            return "회원탈퇴가 완료되었습니다"
        case .findPassword:
            return "이메일로 임시 비밀번호가 전송되었습니다"
        }
    }
}
