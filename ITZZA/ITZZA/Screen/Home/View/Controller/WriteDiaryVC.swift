//
//  WriteDiaryVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WriteDiaryVC: UIViewController {
    
    @IBOutlet weak var dateTitleView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var disposeBag = DisposeBag()
    var selectedDate: String!
    let emotionView = EmotionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUIValue()
        addEmotionView()
        bindUI()
    }
}

// MARK: - Change UI
extension WriteDiaryVC {
    private func setInitialUIValue() {
        cancelButton.contentHorizontalAlignment = .leading
        saveButton.contentHorizontalAlignment = .trailing
        dateLabel.text = selectedDate
    }
    
    private func addEmotionView() {
        view.addSubview(emotionView)
        
        emotionView.snp.makeConstraints {
            $0.top.equalTo(dateTitleView.snp.bottom).offset(27)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(view.frame.width).dividedBy(2.88)
        }
        
        view.layoutIfNeeded()
    }
}

// MARK: - Bindings
extension WriteDiaryVC {
    private func bindUI() {
        cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
