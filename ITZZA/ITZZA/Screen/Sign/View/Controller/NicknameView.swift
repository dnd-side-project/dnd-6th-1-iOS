//
//  NicknameView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/07.
//

import UIKit
import RxSwift
import RxCocoa

class NicknameView: UIView {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var checkDuplicateButton: UIButton!
    @IBOutlet weak var validNicknameLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    let nicknameVM = NicknameVM()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        bindUI()
        bindVM()
        setInitialValue()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        bindUI()
        bindVM()
        setInitialValue()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.nicknameView)
    }
}

// MARK: - Change UI
extension NicknameView {
    private func setInitialValue() {
        checkDuplicateButton.layer.borderColor = UIColor.orange.cgColor
        checkDuplicateButton.layer.borderWidth = 1
        checkDuplicateButton.layer.cornerRadius = 5
        indicatorView.isHidden = true
    }
    
    private func startIndicator() {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    private func stopIndicator() {
        indicatorView.stopAnimating()
    }
    
    func disableCheckButton() {
        checkDuplicateButton.isEnabled = false
    }
    
    func enableCheckButton() {
        checkDuplicateButton.isEnabled = true
    }
    
    private func hideCheckButtonText() {
        checkDuplicateButton.setTitle("", for: .normal)
    }
    
    private func revealCheckButtonText() {
        checkDuplicateButton.setTitle("중복확인", for: .normal)
    }
}

extension NicknameView {
    private func bindUI() {
        checkDuplicateButton.rx.tap
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.hideCheckButtonText()
                owner.disableCheckButton()
                owner.startIndicator()
                owner.nicknameVM.tapCheckDuplicateButton(with: owner.nicknameTextField.text)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        
    }
}
