//
//  Notification+Name.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/20.
//

import Foundation

extension Notification.Name {
    static let whenDeleteImageButtonTapped = Notification.Name("whenDeleteImageButtonTapped")
    static let whenTabViewTapped = Notification.Name("whenTabViewTapped")
    static let whenKeywordContentViewScrolled = Notification.Name("WhenKeywordContentViewScrolled")
    static let whenUserPostListTapped = Notification.Name("whenUserPostListTapped")
    static let popupAlertView = Notification.Name("popupAlertView")
    static let whenDeletePostMenuTapped = Notification.Name("whenDeletePostMenuTapped")
    static let whenEditPostMenuTapped = Notification.Name("whenEditPostMenuTapped")
    static let whenPostSaved = Notification.Name("whenPostSaved")
    static let whenPostEditSaved = Notification.Name("whenPostEditSaved")
}
