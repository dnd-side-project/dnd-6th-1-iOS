//
//  HomeModel.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/25.
//

import UIKit

struct HomeModel: Decodable {
    var dirayId: Int?
    var userId: Int?
    var date: String?
    var categoryId: Int?
    var categoryReason: String?
    var diaryTitle: String?
    var diaryContent: String?
    var diaryCreated: String?
    var year: Int?
    var month: Int?
    var week: Int?
    var diaryStatus: Bool?
    var images: [String]?
}

extension HomeModel {
    var diaryImages : [UIImage]? {
        var diaryImages: [UIImage] = []
        guard let diaryImageURL = images else { return nil }
        
        diaryImageURL.forEach {
            let imageData = try? Data(contentsOf: URL(string: $0)!)
            diaryImages.append(UIImage(data: imageData!)!)
        }
        
        return diaryImages
    }
}
