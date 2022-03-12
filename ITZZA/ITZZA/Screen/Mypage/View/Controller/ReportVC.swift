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
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
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
}
