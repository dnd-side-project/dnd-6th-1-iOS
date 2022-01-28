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
    case sign
}

extension TypeOfViewController {
    func storyboardRepresentation() -> StoryboardRepresentation {
        switch self {
        case .tabBar:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.tabBarSB, storyboardId: Identifiers.itzzaTBC)
        case .home:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.homeSB, storyboardId: Identifiers.homeVC)
        case .community:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.communitySB, storyboardId: Identifiers.communityVC)
        case .mypage:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.mypageSB, storyboardId: Identifiers.mypageVC)
        case .sign:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.signSB, storyboardId: Identifiers.signVC)
        }
    }
}
