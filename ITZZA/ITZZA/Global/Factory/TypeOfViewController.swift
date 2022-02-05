//
//  TypeOfViewController.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/25.
//

import Foundation

enum TypeOfViewController {
    case tabBar
    case home
    case community
    case mypage
    case signIn
    case signUp
    case communityCategory
    case addPost
    case searchPost
}

extension TypeOfViewController {
    func storyboardRepresentation() -> StoryboardRepresentation {
        switch self {
        case .tabBar:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.tabBarSB, storyboardId: Identifiers.itzzaTBC)
        case .home:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.homeSB, storyboardId: Identifiers.homeVC)
        case .community:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.communitySB, storyboardId: Identifiers.communityNC)
        case .mypage:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.mypageSB, storyboardId: Identifiers.mypageVC)
        case .signIn:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.signInSB, storyboardId: Identifiers.signInVC)
        case .signUp:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.signUpSB, storyboardId: Identifiers.signUpVC)
        case .communityCategory:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.categorySB, storyboardId: Identifiers.categoryVC)
        case .addPost:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.addPostSB, storyboardId: Identifiers.addPostVC)
        case .searchPost:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.searchPostSB, storyboardId: Identifiers.searchPostVC)
        }
    }
}
