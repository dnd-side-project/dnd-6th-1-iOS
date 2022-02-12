//
//  PostModel.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import Foundation
import UIKit

struct PostModel: Decodable {
    var userId: Int?
    var boardId: Int?
    var categoryName: String?
    var profileImgURL: String?
    var nickName: String?
    var postTitle: String?
    var postContent: String?
    var createdAt: String?
    var imageCnt: Int?
    var commentCnt: Int?
    var likeCnt: Int?
}

extension PostModel {
    var profileimgURL: URL? {
      guard let profileImgURL = profileImgURL else { return nil }
      return URL(string: profileImgURL)
    }
}

