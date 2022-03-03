//
//  CommentModel.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/22.
//

import Foundation

struct CommentDataModel: Decodable {
    var comment: CommentModel?
    var replies: [CommentModel]?
}

struct CommentModel: Decodable {
    var commentId: Int?
    var nickname: String?
    var profileImage: String?
    var commentContent: String?
    var createdAt: String?
    var canEdit: Bool?
    var writerOrNot: Bool?
}
