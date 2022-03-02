//
//  AgreementView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/09.
//

import UIKit
import RxSwift
import RxCocoa

class AgreementView: UIView {
    
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var contextTextView: UITextView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let agreementVM = AgreementVM()
    var disposeBag = DisposeBag()
    let isValidAgreement = BehaviorRelay(value: false)
    
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
        insertXibView(with: Identifiers.agreementView)
    }
}

// MARK: - Change UI
extension AgreementView {
    private func setInitialValue() {
        checkBoxView.layer.cornerRadius = 5
        checkBoxView.layer.borderWidth = 1
        contextTextView.layer.cornerRadius = 5
        contextTextView.textContainerInset = UIEdgeInsets(top: 16, left: 20, bottom: 20, right: 16)
        contextTextView.font = UIFont.SpoqaHanSansNeoRegular(size: 13)
        contextTextView.text = agreementVM.getTextFile()
        setAsOutlineStatus()
        checkLabel.textColor = .darkGray3
        checkLabel.font = .SpoqaHanSansNeoMedium(size: 15)
        stepLabel.textColor = .primary
        stepLabel.font = .SpoqaHanSansNeoBold(size: 15)
        descriptionLabel.textColor = .darkGray6
        descriptionLabel.font = .SpoqaHanSansNeoBold(size: 20)
    }
    
    func setAsOutlineStatusFromPrevious() {
        checkBoxView.layer.borderColor = UIColor.primary.cgColor
        checkBoxButton.setImage(UIImage(named: "CheckBoxOutline"), for: .normal)
        checkBoxView.backgroundColor = .white
        checkLabel.textColor = .orange
    }
    
    private func setAsOutlineStatus() {
        checkBoxView.layer.borderColor = UIColor.lightGray5.cgColor
        checkBoxButton.setImage(UIImage(named: "CheckBoxOutline"), for: .normal)
        checkBoxView.backgroundColor = .white
        checkLabel.textColor = .darkGray3
        isValidAgreement.accept(false)
    }
    
    private func setAsFillStatus() {
        checkBoxView.layer.borderColor = UIColor.darkGray3.cgColor
        let image = UIImage(named: "CheckBoxFill")?.withRenderingMode(.alwaysTemplate)
        checkBoxButton.setImage(image, for: .normal)
        checkBoxButton.tintColor = .white
        checkBoxView.backgroundColor = .darkGray3
        checkLabel.textColor = .white
        isValidAgreement.accept(true)
    }
}

// MARK: - Bindings
extension AgreementView {
    private func bindUI() {
        checkBoxButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .map { owner, _ in
                owner.checkBoxButton.currentImage?.isEqual(UIImage(named: "CheckBoxOutline"))
            }
            .bind(onNext: { [weak self] status in
                guard let self = self, let status = status else { return }
                self.agreementVM.checkCheckBoxImage(status)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        agreementVM.setCheckBoxOutline
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setAsOutlineStatus()
            })
            .disposed(by: disposeBag)

        agreementVM.setCheckBoxFill
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setAsFillStatus()
            })
            .disposed(by: disposeBag)
    }
}
