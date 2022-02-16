//
//  EmptyDiaryView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/16.
//

import UIKit
import RxSwift
import RxCocoa

class EmptyDiaryView: UIView {
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        setInitialUIValue()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        setInitialUIValue()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.emptyDiaryView)
    }
    
}

// MARK: - Change UI
extension EmptyDiaryView {
    func setInitialUIValue() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
    }
}

// MARK: - Bindings
extension EmptyDiaryView {
    
}
