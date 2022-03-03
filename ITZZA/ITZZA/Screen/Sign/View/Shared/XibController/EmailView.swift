//
//  EmailView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/08.
//

import UIKit
import RxSwift
import RxCocoa

class EmailView: UIView {
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailValidLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var disposeBag = DisposeBag()
    let isValidEmail = BehaviorRelay(value: false)
    let validation = Validation()
    
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
        insertXibView(with: Identifiers.emailView)
    }
}

// MARK: - Bindings
extension EmailView {
    private func bindUI() {
        emailTextField.rx.text.orEmpty
            .bind(to: validation.emailText)
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.emailValidLabel.isHidden = false
            })
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        validation.isEmailVaild.asDriver()
            .do(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.isValidEmail.accept(flag)
            })
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.changeEmailLabel(flag)
                self.changeLineViewColor(flag)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Change UI
extension EmailView {
    private func setInitialValue() {
        emailTextField.returnKeyType = .done
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
        emailTextField.enablesReturnKeyAutomatically = true
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.placeholder = "내용넣기"
        emailValidLabel.isHidden = true
        emailValidLabel.textColor = .lightGray5
        emailValidLabel.font = .SpoqaHanSansNeoRegular(size: 12)
        stepLabel.textColor = .primary
        stepLabel.font = .SpoqaHanSansNeoBold(size: 15)
        descriptionLabel.textColor = .darkGray6
        descriptionLabel.font = .SpoqaHanSansNeoBold(size: 20)
    }
    
    private func changeLineViewColor(_ flag: Bool) {
        if flag {
            lineView.backgroundColor = .primary
        } else {
            lineView.backgroundColor = .lightGray5
        }
    }
    
    private func changeEmailLabel(_ flag: Bool) {
        if flag {
            emailValidLabel.textColor = .primary
            emailValidLabel.text = "유효한 이메일입니다."
        } else {
            emailValidLabel.textColor = .lightGray5
            emailValidLabel.text = "유효하지 않은 이메일입니다."
        }
    }
}
