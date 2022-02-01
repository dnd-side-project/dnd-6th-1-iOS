//
//  DataSourceArticle.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import Foundation
import RxDataSources

struct DataSourceArticle {

    var section: Int
    var items: [Item]

}
extension DataSourceArticle: SectionModelType {
    typealias Item = ModelArticle

    init(original: DataSourceArticle, items: [ModelArticle]) {
        self = original
        self.items = items
    }
}
