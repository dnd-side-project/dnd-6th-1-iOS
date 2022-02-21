//
//  PostModel.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import Foundation
import UIKit
import Kingfisher

struct PostModel: Decodable {
    var boardId: Int?
    var categoryId: Int?
    var profileImage: String?
    var nickname: String?
    var postTitle: String?
    var postContent: String?
    var createdAt: String?
    var imageCnt: Int?
    var images: [String]?
    var commentCnt: Int?
    var comments: [PostComment]?
    var likeCnt: Int?
    var bookmarkStatus: Bool?
    var likeStatus: Bool?
}

struct PostComment: Decodable {
    var nickname: String?
    var profileImage: String?
    var commentContent: String?
    var createAt: String?
    var canEdit: Bool?
    var writerOrNot: Bool?
}

extension PostModel {
    var profileImgURL: URL? {
      guard let profileImgURL = profileImage else { return nil }
      return URL(string: profileImgURL)
    }
    
    var postImages: [UIImage]? {
        var postImages: [UIImage] = []
        guard let postImgURL = images else { return nil }

        postImgURL.forEach { imageURL in
            let data = try? Data(contentsOf: URL(string: imageURL)!)
            postImages.append(UIImage(data: data!)!)
        }

        return postImages
    }
}

