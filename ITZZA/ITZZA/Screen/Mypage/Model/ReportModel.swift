//
//  ReportModel.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/14.
//

import UIKit
import Alamofire

struct ReportPeriodModel: Decodable {
    var year: Int
    var week: Int
}

struct ReportModel: Decodable {
    var emotion: [ReportEmotionModel]?
    var diaries: [ReportDiaryModel]?
}

struct ReportEmotionModel: Decodable {
    var category: Int
    var cnt: Int
    var rank: Int
    var rankChange: Int
}

struct ReportDiaryModel: Decodable {
    var period: String
    var category: Int
    var diary: [HomeModel]
}
