//
//  SearchedResultModel.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/25.
//

import Foundation

struct SearchedResultModel: Decodable {
    var contentResult: [PostModel]?
    var userResult: [PostModel]?
}
