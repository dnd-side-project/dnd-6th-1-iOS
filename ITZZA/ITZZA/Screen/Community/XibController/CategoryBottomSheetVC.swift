//
//  CategoryBottomSheetVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/13.
//

import UIKit
import RxSwift
import RxCocoa
import DynamicBottomSheet
import SnapKit
import Then

class CategoryBottomSheetVC: DynamicBottomSheetViewController {
    
    let bag = DisposeBag()
    let categoryName = CommunityType.allCases
    var delegate: CategoryTitleDelegate?
    
    // MARK: - Private Properties
    
    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
}
// MARK: - Protocol
protocol CategoryTitleDelegate {
    func getCategoryTitle(_ title: String, _ index: Int)
}

// MARK: - Layout

extension CategoryBottomSheetVC {
    
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
        categoryName.filter({
            $0.description != categoryName.first?.description
        }).forEach { title in
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
                    self.delegate?.getCategoryTitle(button.currentTitle ?? "감정을 선택해주세요", title.index)
                    self.dismiss(animated: true, completion: nil)
                })
                .disposed(by: bag)
        }
    }
}
