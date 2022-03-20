//
//  ReportVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos
import Lottie
import SwiftKeychainWrapper

class ReportVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var reportPeriodButton: UIButton!
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var emotionRankCV: UICollectionView!
    @IBOutlet weak var emotionAnalyzeHolderView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var emotionListCV: UICollectionView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var writeDiaryButton: UIButton!
    
    let apiSession = APISession()
    let bag = DisposeBag()
    var reportPeriodList = [ReportPeriodModel]()
    var report = ReportModel()
    let MVPScrollView = UIScrollView()
    var MVPStackView = UIStackView()
    var year: Int?
    var week: Int?
    
    var MVPEmotionCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotification()
        getReportPeriod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLottieAnimation()
    }
}

extension ReportVC {
    // MARK: - Configure
    private func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        
        configureNaviBar()
        configureTitleView()
        configureEmotionRankCV()
        configureEmotionAnalyzeView()
        configureEmotionListCV()
        setWriteDiaryButton()
        
        view.reloadInputViews()
    }
    
    private func configureNaviBar() {
        navigationItem.title = "리포트"
        let saveButton = UIBarButtonItem()
        saveButton.title = "저장"
        navigationItem.rightBarButtonItem = saveButton
        
        saveButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                guard let report = self.scrollView.subviews.first?.transformToImage() else { return }
                
                self.saveViewtoGallery(report)
                self.showToast(with: .reportSaved)
            })
            .disposed(by: bag)
    }
    
    private func configureTitleView() {
        reportPeriodButton.tintColor = .darkGray2
        reportPeriodButton.setTitle("\(year ?? (reportPeriodList.first?.year ?? 0))년 \(week ?? (reportPeriodList.first?.week ?? 0))번째 리포트", for: .normal)
        reportPeriodButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        reportPeriodButton.imageView?.contentMode = .scaleAspectFit
        reportPeriodButton.titleLabel?.font = .SpoqaHanSansNeoMedium(size: 13)
        reportPeriodButton.contentHorizontalAlignment = .left
        reportPeriodButton.semanticContentAttribute = .forceRightToLeft
        reportPeriodButton.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
        bindReportPeriodButton()
        
        if report.diaries?.count != 1 {
            reportTitle.text = "이번 주 감정 순위는 공동 1등!"
        } else {
            reportTitle.text = "이번 주 감정 순위는 '\(Emoji.allCases[(report.emotion?.first?.category ?? 1) - 1].emotion)' 1등!"
        }
        reportTitle.font = .SpoqaHanSansNeoBold(size: 17)
        reportTitle.textColor = .darkGray6
    }
    
    private func bindReportPeriodButton() {
        reportPeriodButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.configureSelectView()
            })
            .disposed(by: bag)
    }
    
    private func configureSelectView() {
        let selectTV = SelectAlertTV()
        selectTV.reportPeriodList = reportPeriodList
        let alertVC = UIViewController.init()
        let alertController = UIAlertController(title: "날짜 선택",
                                                message: "",
                                                preferredStyle: .alert)
        alertController.view.tintColor = .darkGray6
        alertController.view.subviews.first?.subviews.first?.subviews.first!.backgroundColor = .white
        alertController.setValue(alertVC, forKey: "contentViewController")
        alertVC.view.addSubview(selectTV)
        
        let height = (reportPeriodList.count > 6) ? 5 : reportPeriodList.count
        
        alertVC.view.snp.makeConstraints {
            $0.height.equalTo(height * 54)
        }
        selectTV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        present(alertController, animated: true) {
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }
    }
    
    private func configureEmotionRankCV() {
        emotionRankCV.dataSource = self
        emotionRankCV.delegate = self
        
        emotionRankCV.isScrollEnabled = false
        emotionRankCV.reloadData()
    }
    
    private func configureEmotionListCV() {
        emotionListCV.dataSource = self
        emotionListCV.delegate = self
        
        emotionListCV.isScrollEnabled = false
    }
    
    private func setWriteDiaryButton() {
        writeDiaryButton.backgroundColor = .primary
        writeDiaryButton.layer.cornerRadius = 4
        writeDiaryButton.setTitle("일기 작성하기", for: .normal)
        writeDiaryButton.titleLabel?.font = .SpoqaHanSansNeoMedium(size: 12)
        writeDiaryButton.tintColor = .white
    }
    
    private func setLottieAnimation() {
        animationView.clipsToBounds = false
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        animationView.loopMode = .loop
    }
    
    // MARK: - Custom Function
    func saveViewtoGallery(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            DispatchQueue.main.async {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: nil)
            }
        }
    }
    
    func configureNoDataView() {
        // TODO: - 뷰 구조 싹 바꾸기..ㅎ....
    }
    
    @objc func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - EmotionAnalyzeView
    func configureEmotionAnalyzeView() {
        setEmotionAnalyzeScrollView()
        setEmotionAnalyzeStackView()
        setEmotionAnalyzePageController()
        addEmotionAnalyzeView()
        emotionAnalyzeHolderView.reloadInputViews()
    }
    
    func setEmotionAnalyzeScrollView() {
        MVPScrollView.delegate = self
        
        emotionAnalyzeHolderView.addSubview(MVPScrollView)
        MVPScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        MVPScrollView.showsHorizontalScrollIndicator = false
        
        MVPScrollView.contentSize = CGSize(width: emotionAnalyzeHolderView.frame.size.width * CGFloat(MVPEmotionCount ?? 1), height: 0)
        MVPScrollView.isPagingEnabled = true
    }
    
    func setEmotionAnalyzeStackView() {
        MVPStackView.axis = .horizontal
        MVPStackView.alignment = .fill
        MVPScrollView.addSubview(MVPStackView)
        
        MVPStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(MVPScrollView.snp.height)
        }
    }
    
    func setEmotionAnalyzePageController() {
        pageController.numberOfPages = MVPEmotionCount ?? 1
        pageController.currentPage = 0
        pageController.pageIndicatorTintColor = .lightGray5
        pageController.currentPageIndicatorTintColor = .primary
    }
    
    func addEmotionAnalyzeView() {
        MVPStackView.removeAllArrangedSubviews()
        
        for i in 0 ..< (MVPEmotionCount ?? 1) {
            let analyzeView = EmotionAnalyzeView()
            analyzeView.reportDiary = report.diaries?[i]
            analyzeView.configureEmotionAnalyzeView()

            MVPStackView.addArrangedSubview(analyzeView)
            analyzeView.snp.makeConstraints {
                $0.width.equalTo(MVPScrollView.snp.width)
                $0.height.equalTo(MVPScrollView.snp.height)
            }
        }
    }
    
    // MARK: - Notification
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadReportView), name: .whenReportWeekSelected, object: nil)
    }
    
    @objc func reloadReportView(_ notification: Notification) {
        guard let object = notification.object as? [Int?], let year = object[0], let week = object[1] else { return }
        getReport(year: year, week: week)
        self.year = year
        self.week = week
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Network
    func getReportPeriod() {
        let baseURL = "https://www.itzza.shop/users/"
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        guard let url = URL(string: baseURL + "\(userId)/reports") else { return }
        let resource = urlResource<[ReportPeriodModel]>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let reportList):
                    self.reportPeriodList = reportList
                    if reportList.isEmpty {
                        self.configureNoDataView()
                    } else {
                        self.getReport(year: reportList.first!.year ?? 0,
                                       week: reportList.first!.week ?? 0)
                    }
                case .failure:
                    break
                }
            })
            .disposed(by: bag)
    }
    
    func getReport(year: Int, week: Int) {
        let baseURL = "https://www.itzza.shop/users/"
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        guard let url = URL(string: baseURL + "\(userId)/reports?year=\(year)&week=\(week)") else { return }
        let resource = urlResource<ReportModel>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let reportList):
                    self.report = reportList
                    self.MVPEmotionCount = reportList.diaries?.count
                    DispatchQueue.main.async {
                        self.configureView()
                    }
                case .failure:
                    break
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - UICollectionViewDataSource
extension ReportVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case emotionRankCV:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Identifiers.emotionRankCVC,
                for: indexPath) as? EmotionRankCVC
            else { return UICollectionViewCell() }
            
            cell.configureCell(report.emotion![indexPath.row])
            return cell
        case emotionListCV:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Identifiers.emotionListCVC,
                for: indexPath) as? EmotionListCVC
            else { return UICollectionViewCell() }
            cell.backgroundColor = Emoji.allCases[indexPath.row].color
            cell.layer.cornerRadius = 4
            cell.title.text = Emoji.allCases[indexPath.row].name
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReportVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case emotionRankCV:
            return 16
        case emotionListCV:
            return 20
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case emotionRankCV:
            return CGSize(width: collectionView.frame.width - 50,
                          height: 56)
        case emotionListCV:
            return CGSize(width: (collectionView.frame.width - 40) / 5, height: collectionView.frame.height)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case emotionRankCV:
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ReportVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        if page.isNaN || page.isInfinite { return }
        pageController.currentPage = Int(page)
    }
}
