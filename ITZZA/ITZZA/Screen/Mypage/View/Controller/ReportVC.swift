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

class ReportVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var reportPeriodButton: UIButton!
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var emotionRankCV: UICollectionView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

extension ReportVC {
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
    
    func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        
        configureNaviBar()
        configureTitleView()
        configureEmotionRankCV()
    }
    
    func configureTitleView() {
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
    
    func configureEmotionRankCV() {
        emotionRankCV.dataSource = self
        emotionRankCV.delegate = self
        
        emotionRankCV.isScrollEnabled = false
    }
}

extension ReportVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifiers.emotionRankCVC,
            for: indexPath) as? EmotionRankCVC
        else { return UICollectionViewCell() }
        
        cell.configureCell(indexPath.row)
        return cell
    }
}

extension ReportVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - 50,
                      height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 23, left: 0, bottom: 0, right: 0)
    }
}
