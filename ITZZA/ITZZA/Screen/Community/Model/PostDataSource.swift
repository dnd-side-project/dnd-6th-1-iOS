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
    typealias Item = String

    init(original: PostDataSource, items: [String]) {
        self = original
        self.items = items
    }
}
