//
//  HomeAlarmVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/03/10.
//

import RxSwift
import RxCocoa

class HomeAlarmVM {
    
    init() {
        fetchData()
    }
    
    let dummy1 = HomeAlarmModel(id: 1, read: false, type: "like", description: "sdlkfnwel", date: "03-10")
    let dummy2 = HomeAlarmModel(id: 2, read: true, type: "like", description: "sdlkfnwel", date: "03-10")
    let dummy3 = HomeAlarmModel(id: 3, read: false, type: "comment", description: "sdlkfnwel", date: "03-07")
    let dummy4 = HomeAlarmModel(id: 4, read: true, type: "comment", description: "sdlkfnwel", date: "03-07")
    let dummy5 = HomeAlarmModel(id: 5, read: false, type: "like", description: "sdlkfnwel", date: "02-22")
    let dummy6 = HomeAlarmModel(id: 6, read: false, type: "comment", description: "sdlkfnwel", date: "02-23")
    
    var dummyToday = [HomeAlarmModel]()
    var dummyThisWeek = [HomeAlarmModel]()
    var dummyLastMonth = [HomeAlarmModel]()
    
    let sectionArray = ["오늘", "이번 주", "2022-02"]
    
    func fetchData() {
        dummyToday.append(dummy1)
        dummyToday.append(dummy2)
        dummyThisWeek.append(dummy3)
        dummyThisWeek.append(dummy4)
        dummyLastMonth.append(dummy5)
        dummyLastMonth.append(dummy6)
    }
    
    func decideImage(_ type: String) -> UIImage {
        if type == "comment" {
            return UIImage(named: "Heart")!.withRenderingMode(.alwaysTemplate)
        } else {
            return UIImage(named: "Comment")!.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func decideColor(_ flag: Bool) -> UIColor {
        if flag {
            return UIColor.primary
        } else {
            return UIColor.lightGray6
        }
    }
}
