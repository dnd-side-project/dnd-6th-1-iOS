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
    
    private func readTextFile() -> String {
        var result = ""
        let path = Bundle.main.path(forResource: "Agreement.txt", ofType: nil)
        guard path != nil else { return "" }
        
        do {
            result = try String(contentsOfFile: path!, encoding: .utf8)
        }
        catch {
            result = ""
        }
        return result
    }
}

// MARK: - Change UI
extension AgreementView {
    private func setInitialValue() {
        checkBoxView.layer.cornerRadius = 5
        checkBoxView.layer.borderColor = UIColor.orange.cgColor
        checkBoxView.layer.borderWidth = 1
        contextTextView.layer.cornerRadius = 5
        contextTextView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 12)
        contextTextView.font = UIFont.SpoqaHanSansNeoRegular(size: 13)
        contextTextView.text = readTextFile()
        checkLabel.textColor = .orange
        setAsOutlineStatus()
    }
    
    func setAsOutlineStatusFromPrevious() {
        checkBoxButton.setImage(UIImage(named: "CheckBoxOutline"), for: .normal)
        checkBoxView.backgroundColor = .white
        checkLabel.textColor = .orange
    }
    
    private func setAsOutlineStatus() {
        checkBoxButton.setImage(UIImage(named: "CheckBoxOutline"), for: .normal)
        checkBoxView.backgroundColor = .white
        checkLabel.textColor = .orange
        isValidAgreement.accept(false)
    }
    
    private func setAsFillStatus() {
        checkBoxButton.setImage(UIImage(named: "CheckBoxFill"), for: .normal)
        checkBoxView.backgroundColor = .orange
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
