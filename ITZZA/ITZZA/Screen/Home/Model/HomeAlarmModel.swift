//
//  HomeAlarmModel.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/03/10.
//

struct HomeAlarmModel: Decodable {
    var id: Int?
    var read: Bool?
    var type: String?
    var description: String?
    var date: String?
}
