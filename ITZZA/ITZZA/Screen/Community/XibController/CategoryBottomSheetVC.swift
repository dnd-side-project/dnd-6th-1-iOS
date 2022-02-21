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

enum CategoryName: String, CaseIterable {
    case 부정
    case 분노
    case 타협
    case 슬픔
    case 수용
}

class CategoryBottomSheetVC: DynamicBottomSheetViewController {
    
    let bag = DisposeBag()
    let categoryName = CategoryName.allCases
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
    func getCategoryTitle(_ title: String)
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
        categoryName.forEach { title in
            let button = UIButton(type: .system)
                .then {
                    $0.setTitle("\(title)", for: .normal)
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
                .drive(onNext: {
                    self.delegate?.getCategoryTitle(button.currentTitle ?? "감정을 선택해주세요")
                    self.dismiss(animated: true, completion: nil)
                })
                .disposed(by: bag)
        }
    }
}
