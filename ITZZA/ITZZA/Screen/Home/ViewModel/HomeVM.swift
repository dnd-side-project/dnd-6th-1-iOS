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
    var parsedDiaryData: [Date: HomeModel] = [:]
    
    private lazy var dashDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private lazy var dotDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "yyyy.MM.dd"
        return df
    }()
  
    private func extractDateFromData() {
        events = [:]
        parsedDiaryData = [:]
        
        monthlyDiaryData.forEach {
            events[dashDateFormatter.date(from: $0.date!)!] = $0.categoryId
            parsedDiaryData[dashDateFormatter.date(from: $0.date!)!] = $0
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
    
    func distinguishViewToShow(_ date: Date) -> DiaryVC {
        guard let diaryVC = ViewControllerFactory.viewController(for: .diary) as? DiaryVC else {
            return DiaryVC()
        }
        
        diaryVC.seletedDate = dotDateFormatter.string(from: date)
        
        if events.keys.contains(date) {
            let temporalView = EmptyDiaryView()
            let parsedData = parsedDiaryData[date]
            
            temporalView.emotionSentence.text = parsedData?.categoryReason
            temporalView.postContentView.title.text = parsedData?.diaryTitle
            temporalView.postContentView.contents.text = parsedData?.diaryContent
            temporalView.addImagesToImageScrollView(with: parsedData?.diaryImages ?? [])
            temporalView.addImagesToImageScrollView(with: [])
            
            temporalView.emotionSentence.textColor = .darkGray6
            temporalView.postContentView.title.textColor = .darkGray6
            temporalView.postContentView.contents.textColor = .darkGray6
            
            diaryVC.viewStatus = true
            diaryVC.categoryId = parsedData?.categoryId
            diaryVC.emptyDiaryView = temporalView
            return diaryVC
        } else {
            diaryVC.viewStatus = false
            return diaryVC
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
