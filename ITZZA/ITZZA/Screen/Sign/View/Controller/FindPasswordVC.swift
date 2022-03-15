//
//  FindPasswordVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/03/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FindPasswordVC: UIViewController {
    
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var findPasswordButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let validation = Validation()
    let toastView = AlertView()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerConfiguration()
        bindUI()
        bindVM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setToastViewPosition()
        showToastView()
    }
    
    private func viewControllerConfiguration() {
        viewTitleLabel.text = "비밀번호 찾기"
        viewTitleLabel.textColor = .darkGray6
        viewTitleLabel.font = .SpoqaHanSansNeoBold(size: 22)
        descriptionLabel.text = "이메일을 입력하시면,\n임시 비밀번호를 발송해드립니다."
        descriptionLabel.textColor = .darkGray4
        descriptionLabel.font = .SpoqaHanSansNeoBold(size: 17)
        emailTextField.backgroundColor = .textFieldBackgroundColor
        emailTextField.placeholder = "이메일 입력"
        emailTextField.setPlaceholderColor(.lightGray5)
        emailTextField.addLeftPadding()
        emailTextField.layer.cornerRadius = 4
        emailTextField.layer.borderColor = UIColor.primary.cgColor
        findPasswordButton.backgroundColor = .lightGray6
        findPasswordButton.titleLabel?.text = "비밀번호 찾기"
        findPasswordButton.setTitleColor(.white, for: .normal)
        findPasswordButton.titleLabel?.font = .SpoqaHanSansNeoBold(size: 17)
        findPasswordButton.isEnabled = false
        findPasswordButton.layer.cornerRadius = 4
    }
    
}

// MARK: - Bindings
extension FindPasswordVC {
    func bindUI() {
        emailTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: validation.emailText)
            .disposed(by: disposeBag)
        
        findPasswordButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.changeIndicatorUI(true)
            })
            .disposed(by: disposeBag)
    }
    
    func bindVM() {
        validation.isEmailVaild
            .asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.changeButtonUI(flag)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Related to UI
extension FindPasswordVC {
    func changeButtonUI(_ flag: Bool) {
        if flag {
            emailTextField.layer.borderWidth = 0
            findPasswordButton.backgroundColor = .primary
            findPasswordButton.isEnabled = true
        } else {
            emailTextField.layer.borderWidth = 1
            findPasswordButton.backgroundColor = .lightGray6
            findPasswordButton.isEnabled = false
        }
    }
    
    func changeIndicatorUI(_ flag: Bool) {
        if flag {
            self.indicatorView.isHidden = false
            self.indicatorView.startAnimating()
        } else {
            self.indicatorView.stopAnimating()
        }
    }
    
    func setToastViewPosition() {
        view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.top.equalTo(findPasswordButton.snp.bottom).offset(70)
            $0.leading.equalToSuperview().offset(52)
            $0.trailing.equalToSuperview().offset(-52)
            $0.height.equalTo(44)
        }
    }
    
    func showToastView() {
        toastView.setAlertTitle(alertType: .findPassword)
        toastView.showToastView()
    }
}
