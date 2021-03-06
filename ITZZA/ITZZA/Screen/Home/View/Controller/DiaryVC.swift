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
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateTitleView: UIView!
    @IBOutlet weak var writeDiaryButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var seletedDate: String!
    var disposeBag = DisposeBag()
    var diaryView = DiaryView()
    var viewStatus: Bool?
    var emojiAnimationView = EmojiAnimationView()
    var categoryId: Int?
    var diaryId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decideViewToAdd(viewStatus ?? false)
        setInitialUIValue()
        changeViewStatus(viewStatus ?? false)
        bindUI()
    }
}

// MARK: - Change UI
extension DiaryVC {
    private func setInitialUIValue() {
        view.backgroundColor = .calendarBackgroundColor
        dateTitleView.backgroundColor = .calendarBackgroundColor
        dateTitleLabel.textColor = .darkGray6
        dateTitleLabel.font = .SpoqaHanSansNeoBold(size: 20)
        cancelButton.contentHorizontalAlignment = .leading
        cancelButton.setTitleColor(.darkGray6, for: .normal)
        cancelButton.titleLabel?.font = .SpoqaHanSansNeoMedium(size: 15)
        dateTitleLabel.text = seletedDate
        writeDiaryButton.layer.cornerRadius = 4
        writeDiaryButton.titleLabel?.font = .SpoqaHanSansNeoBold(size: 15)
        writeDiaryButton.backgroundColor = .primary
        view.bringSubviewToFront(writeDiaryButton)
    }
    
    private func decideViewToAdd(_ flag: Bool) {
        if flag {
            addEmojiAnimationView()
            addDiaryViewWithAnimation()
        } else {
            addDiaryView()
        }
    }
    
    private func addEmojiAnimationView() {
        view.addSubview(emojiAnimationView)
        emojiAnimationView.configureLottieAnimation(with: categoryId ?? 0)
        
        emojiAnimationView.snp.makeConstraints {
            $0.top.equalTo(dateTitleView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(171)
        }
    }
    
    private func addDiaryView() {
        view.addSubview(diaryView)
        
        diaryView.snp.makeConstraints {
            $0.top.equalTo(dateTitleView.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func addDiaryViewWithAnimation() {
        view.addSubview(diaryView)
        
        diaryView.snp.makeConstraints {
            $0.top.equalTo(emojiAnimationView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func dismissDiaryVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeViewStatus(_ status: Bool) {
        if status {
            writeDiaryButton.isHidden = true
        } else {
            menuButton.isHidden = true
        }
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
                guard let writeDiaryVC = ViewControllerFactory.viewController(for: .writeDiary)
                                            as? WriteDiaryVC else { return }
                
                writeDiaryVC.selectedDate = self.seletedDate
                self.present(writeDiaryVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        menuButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let menuBottomSheet = MenuBottomSheet()
                menuBottomSheet.activateMenuButtonForDiary(self.diaryId)
                self.present(menuBottomSheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
