//
//  MypageModel.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/26.
//

import UIKit

struct MypageModel: Codable {
    var user: UserObject?
    var writeCnt: Int?
    var commentCnt: Int?
    var bookmarkCnt: Int?
}

struct UserObject: Codable {
    var email: String?
    var nickname: String?
    var profileImage: String?
}

extension MypageModel {
    var profileImageData: UIImage? {
        guard let user = user, let baseURL = user.profileImage else { return nil }
        let url = URL(string: baseURL)!
        let data = try? Data(contentsOf: url)
        let imageData = UIImage(data: data ?? Data())
        return imageData ?? UIImage()
    }
}
