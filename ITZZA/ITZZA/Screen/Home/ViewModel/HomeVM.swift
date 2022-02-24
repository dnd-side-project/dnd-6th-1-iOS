//
//  HomeVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/25.
//

import RxSwift
import RxCocoa

class HomeVM {
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    let apiError = PublishSubject<APIError>()
    let getDiarySuccess = PublishSubject<[Date: Int]>()
    var monthlyDiaryData: [HomeModel] = []
    var events: [Date: Int] = [:]
    
    private lazy var dashDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
  
    private func extractDateFromData() {
        events = [:]
        monthlyDiaryData.forEach {
            events[dashDateFormatter.date(from: $0.date!)!] = $0.categoryId
        }
    }
    
    func decideEventColor(_ date: Date) -> [UIColor] {
        if events[date] == 1 {
            return [UIColor.seconAngry]
        } else if events[date] == 2 {
            return [UIColor.seconRelaxed]
        } else if events[date] == 3 {
            return [UIColor.seconConfused]
        } else if events[date] == 4 {
            return [UIColor.seconSorrow]
        } else {
            return [UIColor.seconLonely]
        }
    }
}

// MARK: - Networking
extension HomeVM {
    func getDiaryData(_ month: String, _ year: String) {
        let baseURL = "http://13.125.239.189:3000/diaries?month=\(month)&year=\(year)"
        let url = URL(string: baseURL)!
        let resource = urlResource<[HomeModel]>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    
                case .success(let response):
                    owner.monthlyDiaryData = response
                    owner.extractDateFromData()
                    owner.getDiarySuccess.onNext(owner.events)
                }
            })
            .disposed(by: disposeBag)
    }
}
