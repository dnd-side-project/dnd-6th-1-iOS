//
//  PostDataSource.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import Foundation
import RxDataSources

struct PostDataSource {

    var section: Int
    var items: [Item]

}
extension PostDataSource: SectionModelType {
    typealias Item = PostModel

    init(original: PostDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
