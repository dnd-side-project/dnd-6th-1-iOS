//
//  MyRecordData.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/26.
//

import Foundation

struct MyRecordModel: Decodable {
    var boards = [PostModel]()
    var comments = [PostModel]()
    var bookmarks = [PostModel]()
}
