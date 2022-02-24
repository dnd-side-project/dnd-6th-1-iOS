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
    let menu = ["수정", "삭제"]
    
    // MARK: - Private Properties
    
    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fillEqually
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
        menu.forEach { title in
            let button = UIButton(type: .system)
                .then {
                    $0.setTitle(title.description, for: .normal)
                    $0.titleLabel?.font = UIFont.SpoqaHanSansNeoRegular(size: 17)
                    $0.tintColor = .darkGray6
                    $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
                }
            
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints {
                $0.height.equalTo(62)
            }
            
            button.rx.tap
                .asDriver()
                .drive(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: .whenDeletePostMenuTapped, object: nil)
                })
                .disposed(by: bag)
        }
    }
}
