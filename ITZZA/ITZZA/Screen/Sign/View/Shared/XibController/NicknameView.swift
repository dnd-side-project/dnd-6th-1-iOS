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
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var disposeBag = DisposeBag()
    let nicknameVM = NicknameVM()
    let isValidNickname = BehaviorRelay(value: false)
    
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
        checkDuplicateButton.layer.borderColor = UIColor.primary.cgColor
        checkDuplicateButton.layer.borderWidth = 1
        checkDuplicateButton.layer.cornerRadius = 5
        checkDuplicateButton.backgroundColor = .primary
        checkDuplicateButton.setTitleColor(.white, for: .normal)
        checkDuplicateButton.titleLabel?.font = .SpoqaHanSansNeoMedium(size: 12)
        checkDuplicateButton.isEnabled = false
        indicatorView.isHidden = true
        validNicknameLabel.isHidden = true
        validNicknameLabel.textColor = .primary
        underlineView.backgroundColor = .lightGray5
        stepLabel.textColor = .primary
        stepLabel.font = .SpoqaHanSansNeoBold(size: 15)
        descriptionLabel.textColor = .darkGray6
        descriptionLabel.font = .SpoqaHanSansNeoBold(size: 20)
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
    
    private func availableNickname() {
        validNicknameLabel.isHidden = false
        validNicknameLabel.text = "사용가능한 닉네임입니다."
        checkDuplicateButton.setTitleColor(.primary, for: .normal)
        checkDuplicateButton.setTitle("확인완료", for: .normal)
        checkDuplicateButton.backgroundColor = .white
        underlineView.backgroundColor = .orange
    }
    
    private func unavailableNickname() {
        validNicknameLabel.isHidden = false
        validNicknameLabel.text = "같은 닉네임이 존재합니다."
        checkDuplicateButton.setTitle("중복확인", for: .normal)
        checkDuplicateButton.backgroundColor = .primary
        checkDuplicateButton.setTitleColor(.white, for: .normal)
        underlineView.backgroundColor = .orange
    }
    
    private func serverError() {
        validNicknameLabel.isHidden = false
        validNicknameLabel.text = "서버 에러! 다시 시도해주세요."
        checkDuplicateButton.setTitle("중복확인", for: .normal)
        checkDuplicateButton.backgroundColor = .primary
        checkDuplicateButton.setTitleColor(.white, for: .normal)
        underlineView.backgroundColor = .orange
    }
    
    private func decideStatusOfDuplicateCheckButton(_ status: Bool) {
        isValidNickname.accept(false)
        checkDuplicateButton.setTitle("중복확인", for: .normal)
        underlineView.backgroundColor = .lightGray5
        validNicknameLabel.isHidden = true
        
        if status {
            enableCheckButton()
            checkDuplicateButton.backgroundColor = .primary
            checkDuplicateButton.layer.borderColor = UIColor.primary.cgColor
            checkDuplicateButton.setTitleColor(.white, for: .normal)
        } else {
            disableCheckButton()
            checkDuplicateButton.backgroundColor = .white
            checkDuplicateButton.layer.borderColor = UIColor.lightGray5.cgColor
            checkDuplicateButton.setTitleColor(.lightGray5, for: .normal)
        }
    }
    
    func checkDupliacteAgain() {
        checkDuplicateButton.backgroundColor = .white
        checkDuplicateButton.setTitle("중복확인", for: .normal)
        underlineView.backgroundColor = .gray
        validNicknameLabel.isHidden = true
        checkDuplicateButton.layer.borderColor = UIColor.orange.cgColor
        checkDuplicateButton.setTitleColor(.orange, for: .normal)
    }
}

extension NicknameView {
    private func bindUI() {
        nicknameTextField.rx.text.orEmpty
            .bind(to: nicknameVM.nicknameTextField)
            .disposed(by: disposeBag)
        
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
        nicknameVM.emptyTextField
            .asDriver()
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.decideStatusOfDuplicateCheckButton(flag)
            })
            .disposed(by: disposeBag)
        
        nicknameVM.availableNickname
            .asDriver()
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.availableNickname()
                self.stopIndicator()
                self.enableCheckButton()
                self.isValidNickname.accept(true)
            })
            .disposed(by: disposeBag)
        
        nicknameVM.duplicateNickname
            .asDriver()
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.unavailableNickname()
                self.stopIndicator()
                self.enableCheckButton()
                self.isValidNickname.accept(false)
            })
            .disposed(by: disposeBag)
        
        nicknameVM.serverError
            .asDriver()
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.serverError()
                self.stopIndicator()
                self.enableCheckButton()
                self.isValidNickname.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
