//
//  TabCVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/23.
//

import SnapKit
import Then
import UIKit

class TabCVC: UICollectionViewCell {
    
    var indicatorView = UIView()
        .then {
            $0.backgroundColor = .clear
        }
    
    var label = UILabel()
        .then {
            $0.textColor = .darkGray2
            $0.textAlignment = .center
            $0.font = .SpoqaHanSansNeoMedium(size: 15)
        }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        layoutView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        configureSelected()
    }
    
    override var isSelected: Bool {
        didSet {
            configureSelected()
        }
    }
    
    private func configureSelected() {
        if isSelected {
            label.textColor = .primary
            label.font = .SpoqaHanSansNeoBold(size: 15)
            indicatorView.backgroundColor = .primary
            return
        }
        
        label.textColor = .darkGray2
        label.font = .SpoqaHanSansNeoMedium(size: 15)
        indicatorView.backgroundColor = .clear
    }
}

extension TabCVC {
    private func configureView() {
        contentView.addSubview(indicatorView)
        contentView.addSubview(label)
    }

    func configureCell(with menu: String) {
        label.text = menu
    }
}

// MARK: - Layout

extension TabCVC {
    private func layoutView() {
        layoutContainerView()
        layoutLabel()
    }
    
    private func layoutContainerView() {
        indicatorView.snp.makeConstraints {
            $0.width.equalTo(label.snp.width).offset(12)
            $0.height.equalTo(2)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func layoutLabel() {
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
