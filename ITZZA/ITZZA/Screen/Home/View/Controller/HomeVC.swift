//
//  HomeVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/25.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var calendarNextPageButton: UIButton!
    @IBOutlet weak var calendarPreviousPageButton: UIButton!
    @IBOutlet weak var calendarMonthLabel: UILabel!
    @IBOutlet weak var calendarYearLabel: UILabel!
    @IBOutlet weak var writeTodayDiaryButton: UIButton!
    
    var disposeBag = DisposeBag()
    let homeVM = HomeVM()
    private var currentPage: Date?
    
    private lazy var today: Date = {
        return Date()
    }()
    
    private lazy var monthDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "M월"
        return df
    }()
    
    private lazy var yearDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "yyyy"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUIValue()
        calendarDefaultState()
        setDate()
        bindUI()
    }
}

// MARK: - Change UI
extension HomeVC {
    private func setInitialUIValue() {
        writeTodayDiaryButton.layer.cornerRadius = 5
        calendarView.layer.shadowOpacity = 0.1
        calendarView.layer.shadowOffset = CGSize(width: 0, height: -1)
        calendarView.layer.shadowRadius = 5
        calendarView.layer.masksToBounds = false
    }
    
    private func calendarDefaultState() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.appearance.todayColor = .orange
        calendarView.appearance.selectionColor = .calendarBackgroundColor
        calendarView.appearance.titleSelectionColor = .black
        
        calendarView.layer.cornerRadius = 4
        calendarView.locale = Locale(identifier: "en_US")
        calendarView.backgroundColor = .calendarBackgroundColor
        
        calendarView.headerHeight = 100
        calendarView.calendarHeaderView.isHidden = true
        
        calendarView.appearance.weekdayTextColor = .black
        calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        calendarView.appearance.weekdayFont = UIFont.SFProDisplayMedium(size: 13)
    }
    
    private func scrollCurrentPage(_ isPrevious: Bool) {
        let current = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrevious ? -1 : 1
        
        currentPage = current.date(byAdding: dateComponents, to: currentPage ?? self.today)
        calendarView.setCurrentPage(currentPage!, animated: true)
    }
}

// MARK: - Calendar Delegates
extension HomeVC: FSCalendarDelegate {
    private func setDate() {
        calendarMonthLabel.text = monthDateFormatter.string(from: calendarView.currentPage)
        calendarYearLabel.text = yearDateFormatter.string(from: calendarView.currentPage)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarMonthLabel.text = monthDateFormatter.string(from: calendar.currentPage)
        calendarYearLabel.text = yearDateFormatter.string(from: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let diaryVC = ViewControllerFactory.viewController(for: .diary) as? DiaryVC else { return }
        diaryVC.modalPresentationStyle = .fullScreen
        diaryVC.seletedDate = dateFormatter.string(from: date)
        
        self.present(diaryVC, animated: true, completion: nil)
    }
}

// MARK: - Calendar Datasource
extension HomeVC: FSCalendarDataSource {
    
}

extension HomeVC: FSCalendarDelegateAppearance {
    // calendar
}

// MARK: - Bindings
extension HomeVC {
    private func bindUI() {
        calendarPreviousPageButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.scrollCurrentPage(true)
            })
            .disposed(by: disposeBag)
        
        calendarNextPageButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.scrollCurrentPage(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        
    }
}
