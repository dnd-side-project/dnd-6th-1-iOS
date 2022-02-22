//
//  HomeVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/25.
//

import UIKit
import SnapKit
import FSCalendar
import Lottie
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var calendarNextPageButton: UIButton!
    @IBOutlet weak var calendarPreviousPageButton: UIButton!
    @IBOutlet weak var writeTodayDiaryButton: UIButton!
    @IBOutlet weak var calendarYearLabel: UILabel!
    @IBOutlet weak var calendarMonthLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    private var homeAlarmButton: UIBarButtonItem!
    
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
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "yyyy.MM.dd"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setInitialUIValue()
        setLottieAnimation()
        calendarDefaultState()
        setDate()
        bindUI()
    }
}

// MARK: - Change UI
extension HomeVC {
    private func configureNavigationBar() {
        setNaviBarView()
        setNaviBarItem()
    }
    
    private func setNaviBarView() {
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
    }
    
    private func setNaviBarItem() {
        homeAlarmButton = UIBarButtonItem()
        homeAlarmButton.image = UIImage(named: "Home_Alarm")
        navigationItem.rightBarButtonItem = homeAlarmButton
    }
    
    private func setInitialUIValue() {
        writeTodayDiaryButton.layer.cornerRadius = 5
        calendarView.layer.cornerRadius = 4
        calendarView.backgroundColor = .calendarBackgroundColor
    }
    
    private func setLottieAnimation() {
        animationView.clipsToBounds = false
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        animationView.loopMode = .loop
    }
    
    private func calendarDefaultState() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.appearance.todayColor = .orange
        calendarView.appearance.selectionColor = .calendarBackgroundColor
        calendarView.appearance.titleSelectionColor = .black
        
        calendarView.locale = Locale(identifier: "en_US")

        calendarView.headerHeight = 78
        calendarView.calendarHeaderView.isHidden = true
        
        calendarView.appearance.weekdayTextColor = .black
        calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        calendarView.appearance.weekdayFont = UIFont.SpoqaHanSansNeoMedium(size: 13)
    }
    
    private func scrollCurrentPage(_ isPrevious: Bool) {
        let current = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrevious ? -1 : 1
        
        currentPage = current.date(byAdding: dateComponents, to: currentPage ?? self.today)
        calendarView.setCurrentPage(currentPage!, animated: true)
    }
    
    private func moveToWriteDiaryView() {
        guard let writeDiaryVC = ViewControllerFactory.viewController(for: .writeDiary) as? WriteDiaryVC else { return }
        
        writeDiaryVC.selectedDate = dateFormatter.string(from: today)
        self.present(writeDiaryVC, animated: true, completion: nil)
    }
    
    private func moveToHomeAlarmView() {
        guard let homeAlarmTVC = ViewControllerFactory.viewController(for: .homeAlarm) as? HomeAlarmTVC else { return }
        
        homeAlarmTVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(homeAlarmTVC, animated: true)
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
        
        guard let diaryVC = ViewControllerFactory.viewController(for: .diary) as? DiaryVC else { return }
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
        
        writeTodayDiaryButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.moveToWriteDiaryView()
            })
            .disposed(by: disposeBag)
        
        homeAlarmButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.moveToHomeAlarmView()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        
    }
}
