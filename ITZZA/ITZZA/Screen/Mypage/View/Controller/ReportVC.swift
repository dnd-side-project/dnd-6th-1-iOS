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

class ReportVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var reportPeriodButton: UIButton!
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var emotionRankCV: UICollectionView!
    @IBOutlet weak var emotionAnalyzeView: EmotionAnalyzeView!
    @IBOutlet weak var emotionListCV: UICollectionView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var writeDiaryButton: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        emotionAnalyzeView.diaryCount = 4
        emotionAnalyzeView.configureDiaryListCV()
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
        configureEmotionListCV()
        setWriteDiaryButton()
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
                
                guard let report = self.scrollView.subviews.first?.transfromToImage() else { return }
                
                self.saveImage(report)
            })
            .disposed(by: bag)
    }
    
    private func configureTitleView() {
        reportPeriodButton.tintColor = .darkGray2
        reportPeriodButton.setTitle("2022년 11번째 리포트", for: .normal)
        reportPeriodButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        reportPeriodButton.imageView?.contentMode = .scaleAspectFit
        reportPeriodButton.titleLabel?.font = .SpoqaHanSansNeoMedium(size: 13)
        reportPeriodButton.contentHorizontalAlignment = .left
        reportPeriodButton.semanticContentAttribute = .forceRightToLeft
        
        reportTitle.text = "이번 주 감정 순위는 '혼란함' 1등!"
        reportTitle.font = .SpoqaHanSansNeoBold(size: 17)
        reportTitle.textColor = .darkGray6
    }
    
    private func configureEmotionRankCV() {
        emotionRankCV.dataSource = self
        emotionRankCV.delegate = self
        
        emotionRankCV.isScrollEnabled = false
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
    func saveImage(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            DispatchQueue.main.async {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: nil)
            }
        }
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
            
            cell.configureCell(indexPath.row)
            return cell
        case emotionListCV:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Identifiers.emotionListCVC,
                for: indexPath) as? EmotionListCVC
            else { return UICollectionViewCell() }
            cell.backgroundColor = Emoji.allCases[indexPath.row].color
            cell.layer.cornerRadius = 4
            cell.title.text = Emoji.allCases[indexPath.row].name
            cell.setTitleColor()
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
            return UIEdgeInsets(top: 23, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets()
        }
    }
}
