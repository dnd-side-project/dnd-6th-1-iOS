//
//  WriteDiaryVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/16.
//

import UIKit
import RxSwift
import RxCocoa

class WriteDiaryVC: UIViewController {
    
    @IBOutlet weak var dateTitleView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var disposeBag = DisposeBag()
    var selectedDate: String!
    let emotionButtonView = EmotionButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUIValue()
        addEmotionButtonView()
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
    
    private func addEmotionButtonView() {
        view.addSubview(emotionButtonView)
        
        emotionButtonView.snp.makeConstraints {
            $0.top.equalTo(dateTitleView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.layoutIfNeeded()
        emotionButtonView.setButtonCornerRadius()
        emotionButtonView.enlargeButtonImage()
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
