//
//  PostModel.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire

struct PostModel: Decodable {
    var boardId: Int?
    var categoryId: Int?
    var profileImage: String?
    var nickname: String?
    var postTitle: String?
    var postContent: String?
    var createdAt: String?
    var imageCnt: Int?
    var images: [ImagesModel]?
    var commentCnt: Int?
    var comments: [CommentDataModel]?
    var likeCnt: Int?
    var bookmarkStatus: Bool?
    var likeStatus: Bool?
}

extension PostModel {
    var postParam: Parameters {
        return ["categoryId": categoryId!,
                "postTitle": postTitle!,
                "postContent": postContent!
        ]
    }
}

extension PostModel {
    var profileImgURL: URL? {
        guard let profileImgURL = profileImage else { return nil }
        let encodedStr = profileImgURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedStr)!
        return url
    }
    
    var postImages: [UIImage]? {
        var postImages: [UIImage] = []
        guard let postImgURL = images else { return nil }

        postImgURL.forEach { imageURL in
            let encodedStr = imageURL.imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encodedStr!)!

            let data = try? Data(contentsOf: url)
            postImages.append(UIImage(data: data!)!)
        }

        return postImages
    }
}

