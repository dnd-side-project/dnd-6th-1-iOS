//
//  DiaryVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DiaryVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var dateTitleView: UIView!
    @IBOutlet weak var writeDiaryButton: UIButton!
    
    var seletedDate: String!
    var disposeBag = DisposeBag()
    let emptyDiaryView = EmptyDiaryView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEmptyDiaryView()
        setInitialUIValue()
        bindUI()
    }
    
    
}

// MARK: - Change UI
extension DiaryVC {
    private func setInitialUIValue() {
        view.backgroundColor = .calendarBackgroundColor
        dateTitleView.backgroundColor = .calendarBackgroundColor
        cancelButton.contentHorizontalAlignment = .leading
        dateTitle.text = seletedDate
        cancelButton.setTitleColor(.orange, for: .normal)
        writeDiaryButton.layer.cornerRadius = 4
        view.bringSubviewToFront(writeDiaryButton)
    }
    
    private func addEmptyDiaryView() {
        view.addSubview(emptyDiaryView)
        
        emptyDiaryView.snp.makeConstraints {
            $0.top.equalTo(dateTitleView.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func dismissDiaryVC() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Bingdings
extension DiaryVC {
    private func bindUI() {
        cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismissDiaryVC()
            })
            .disposed(by: disposeBag)
        
        writeDiaryButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let writeDiaryVC = ViewControllerFactory.viewController(for: .writeDiary) as? WriteDiaryVC else { return }
                
                writeDiaryVC.modalPresentationStyle = .fullScreen
                self.present(writeDiaryVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
