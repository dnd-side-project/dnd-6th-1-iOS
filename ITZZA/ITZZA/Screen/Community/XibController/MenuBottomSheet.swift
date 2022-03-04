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
    
    override func configureView() {
        super.configureView()
        layoutStackView()
        setButtons()
    }
    
    private func layoutStackView() {
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setButtons() {
        stackView.addArrangedSubview(editButton)
        editButton.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        stackView.addArrangedSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.height.equalTo(62)
        }
    }
    
    func bindButtonAction(_ editNotificationName: Notification.Name, _ deleteNotificationName: Notification.Name) {
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
}
