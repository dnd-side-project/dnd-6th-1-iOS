//
//  TypeOfViewController.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/25.
//

import Foundation

enum TypeOfViewController {
    case onboarding
    case tabBar
    case home
    case community
    case mypage
    case signIn
    case signUp
    case communityCategory
    case postDetail
    case addPost
    case searchPost
    case userPostList

    case diary
    case writeDiary
    case homeAlarm
    case findPassword
    case withdrawal
    
    case myRecord
    case report
}

extension TypeOfViewController {
    func storyboardRepresentation() -> StoryboardRepresentation {
        switch self {
        case .onboarding:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.onboardingSB, storyboardId: Identifiers.onboardingVC)
        case .tabBar:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.tabBarSB, storyboardId: Identifiers.itzzaTBC)
        case .home:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.homeSB, storyboardId: Identifiers.homeNC)
        case .community:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.communitySB, storyboardId: Identifiers.communityNC)
        case .mypage:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.mypageSB, storyboardId: Identifiers.mypageNC)
        case .signIn:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.signInSB, storyboardId: Identifiers.signInVC)
        case .signUp:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.signUpSB, storyboardId: Identifiers.signUpVC)
        case .communityCategory:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.categorySB, storyboardId: Identifiers.categoryVC)
        case .postDetail:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.postDetailSB, storyboardId: Identifiers.postDetailVC)
        case .addPost:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.addPostSB, storyboardId: Identifiers.addPostVC)
        case .searchPost:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.searchPostSB, storyboardId: Identifiers.searchPostVC)
        case .userPostList:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.userPostListSB, storyboardId: Identifiers.userPostListVC)
        case .diary:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.diarySB, storyboardId: Identifiers.diaryVC)
        case .writeDiary:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.writeDiarySB, storyboardId: Identifiers.writeDiaryVC)
        case .homeAlarm:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.homeAlarmSB, storyboardId: Identifiers.homeAlarmTVC)
        case .myRecord:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.myRecordSB, storyboardId: Identifiers.myRecordVC)
        case .report:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.reportSB, storyboardId: Identifiers.reportVC)
        case .findPassword:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.findPasswordSB, storyboardId: Identifiers.findPasswordVC)
        case .withdrawal:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.withdrawalSB, storyboardId: Identifiers.withdrawalVC)
        }
    }
}
