//
//  ModelArticle.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import Foundation
import UIKit

struct ModelArticle: Decodable {
    var nickName: String?
    var profileImgURL: String?
    var likeCnt: Int?
    var commentCnt: Int?
    var bookmarkCnt: Int?
    var createdAt: String?
    var boardId: Int?
    var categoryName: String?
    var postTitle: String?
    var postContent: String?
    var imageCnt: Int?
}

extension ModelArticle {
    var timeStamp: String? {
        guard let createdAt = createdAt,
              let first = createdAt.split(separator: "T").first else {
                  return nil
              }
        return String(first)
    }
    
    var profileimgURL: URL? {
      guard let profileImgURL = profileImgURL else { return nil }
      return URL(string: profileImgURL)
    }
}

