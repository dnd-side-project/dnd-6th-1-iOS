//
//  CommunityType.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/14.
//

import Foundation

enum CommunityType: Int, CaseIterable {
    case all
    case escapism
    case aggressive
    case compromise
    case sadness
    case accept
}

extension CommunityType: CustomStringConvertible {
    var description: String {
        switch self {
        case .all: return "전체"
        case .escapism: return "부정"
        case .aggressive: return "분노"
        case .compromise: return "타협"
        case .sadness: return "슬픔"
        case .accept: return "수용"
        }
    }
    
    var apiQuery: String {
        switch self {
        case .all:
            return ""
        default:
            return "?category=\(rawValue)"
        }
    }
    
    var viewControllerType: TypeOfViewController {
        .communityCategory
    }
}
