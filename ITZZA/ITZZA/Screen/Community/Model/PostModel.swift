//
//  PostModel.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import Foundation
import UIKit

struct PostModel: Decodable {
    var boardId: Int?
    var categoryId: Int?
    var profileImage: String?
    var nickname: String?
    var postTitle: String?
    var postContent: String?
    var createdAt: String?
    var imageCnt: Int?
    var commentCnt: Int?
    var likeCnt: Int?
    var bookmarkStatus: Bool?
    var likeStatus: Bool?
}

extension PostModel {
    var profileimgURL: URL? {
      guard let profileImgURL = profileImage else { return nil }
      return URL(string: profileImgURL)
    }
}

