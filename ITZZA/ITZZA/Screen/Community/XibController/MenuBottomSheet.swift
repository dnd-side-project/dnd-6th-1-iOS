//
//  MenuBottomSheet.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/24.
//

import UIKit
import RxSwift
import RxCocoa
import DynamicBottomSheet
import SnapKit
import Then

class MenuBottomSheet: DynamicBottomSheetViewController {
    
    let bag = DisposeBag()
    let apiSession = APISession()
    var commentId: Int?
    var commentIndex: Int?
    
    // MARK: - Private Properties
    
    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    
    private let editButton = UIButton()
        .then {
            $0.setTitle("수정", for: .normal)
            $0.titleLabel?.font = UIFont.SpoqaHanSansNeoRegular(size: 17)
            $0.setTitleColor(.darkGray6, for: .normal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
    
    private let deleteButton = UIButton()
        .then {
            $0.setTitle("삭제", for: .normal)
            $0.titleLabel?.font = UIFont.SpoqaHanSansNeoRegular(size: 17)
            $0.setTitleColor(.darkGray6, for: .normal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
}

// MARK: - Layout

extension MenuBottomSheet {
    // MARK: - Configuration
    override func configureView() {
        super.configureView()
        setStackViewLayout()
        setButtonsLayout()
    }
    
    // MARK: - Layout
    private func setStackViewLayout() {
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setButtonsLayout() {
        stackView.addArrangedSubview(editButton)
        editButton.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        stackView.addArrangedSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.height.equalTo(62)
        }
    }
    
    // MARK: - Bind button
    func activateMenuButtonForCommunity(_ editNotificationName: Notification.Name, _ deleteNotificationName: Notification.Name) {
        editButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: editNotificationName,
                                                    object: [(self.commentId ?? 0), (self.commentIndex ?? 0)])
                }
            })
            .disposed(by: bag)
        
        deleteButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: deleteNotificationName,
                                                    object: [(self.commentId ?? 0), (self.commentIndex ?? 0)])
                }
            })
            .disposed(by: bag)
    }
    
    func activateMenuButtonForDiary(_ diaryId: Int?) {
        editButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let diaryVC = self.presentingViewController as? DiaryVC else { return }
    
                self.dismiss(animated: true) {
                    diaryVC.present(self.makeWriteDiaryVC(diaryVC, diaryId),
                                    animated: true, completion: nil)
                }
            })
            .disposed(by: bag)
        
        deleteButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showDeleteDiaryMessage(diaryId)
            })
            .disposed(by: bag)
    }
}

// MARK: - View 관련 함수
extension MenuBottomSheet {
    private func makeWriteDiaryVC(_ diaryVC: DiaryVC,
                                  _ diaryId: Int?) -> WriteDiaryVC {
        
        guard let writeDiaryVC = ViewControllerFactory
                                .viewController(for: .writeDiary)
                                as? WriteDiaryVC else { return WriteDiaryVC()}
        
        writeDiaryVC.selectedDate = diaryVC.seletedDate
        writeDiaryVC.emotionTextField.text = diaryVC.diaryView.emotionSentence.text
        let postContentView = diaryVC.diaryView.postContentView
        writeDiaryVC.postWriteView.title.text = postContentView?.title.text
        writeDiaryVC.postWriteView.contents.text = postContentView?.contents.text
        writeDiaryVC.writeDirayVM
            .addImageToCollectionView(diaryVC.diaryView.imageScrollView.image,
                                      writeDiaryVC.imageListView)
        writeDiaryVC.setImageCVHeight(diaryVC.diaryView.imageScrollView.image.count)
        writeDiaryVC.writeDirayVM.isPatch = true
        writeDiaryVC.writeDirayVM.diaryId = diaryId
        
        return writeDiaryVC
    }
    
    private func showDeleteDiaryMessage(_ diaryId: Int?) {
        let alertController = UIAlertController(title: "정말 삭제하시겠어요?",
                                                message: .none,
                                                preferredStyle: .alert)
        
        alertController.view.tintColor = .darkGray6
        alertController.view.backgroundColor = .white
        alertController.view.layer.cornerRadius = 4
        
        let ok = UIAlertAction(title: "네", style: .destructive) { action in
            let baseURL = "http://3.36.71.216:3000/diaries/\(diaryId ?? 0)"
            let url = URL(string: baseURL)!
            let resource = urlResource<DeleteDiaryModel>(url: url)
            
            self.apiSession.deleteRequest(with: resource)
                .withUnretained(self)
                .subscribe(onNext: { owner, result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.showServerErrorAlert(.none)
                        
                    case .success(_):
                        let itzzaTBC = self.presentingViewController?
                                        .presentingViewController as! ITZZATBC
                        let homeNC = itzzaTBC.viewControllers![0] as! HomeNC
                        let homeVC = homeNC.viewControllers.first as! HomeVC
                        
                        itzzaTBC.dismiss(animated: true) {
                            homeVC.getFirstDiaryData()
                        }
                    }
                })
                .disposed(by: self.bag)
        }
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
}
