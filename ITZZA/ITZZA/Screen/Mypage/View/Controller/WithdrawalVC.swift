//
//  WithdrawalVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/03/14.
//

import UIKit
import RxSwift
import RxCocoa

class WithdrawalVC: UIViewController {
    
    @IBOutlet weak var askingLabel: UILabel!
    @IBOutlet weak var withdrawalImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var withdrawalButton: UIButton!
    
    var disposeBag = DisposeBag()
    let withdrawalVM = WithdrawalVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerConfiguration()
        navigationConfiguration()
        bindUI()
        bindVM()
    }
    
    private func navigationConfiguration() {
        navigationController?.setBackButtonWithTitle(navigationItem: self.navigationItem, title: "")
   
        navigationController?.setSub(navigationItem: self.navigationItem,
                                     navigationBar: self.navigationController?.navigationBar,
                                     title: "계정 삭제")
        
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .darkGray6)
    }
    
    private func viewControllerConfiguration() {
        askingLabel.text = "정말 계정을 삭제하시겠어요?"
        askingLabel.textColor = .darkGray6
        askingLabel.font = .SpoqaHanSansNeoBold(size: 17)
        withdrawalImage.image = UIImage(named: "Withdrawal")
        descriptionLabel.text = "회원 탈퇴 시 다음과 같은 내용이 사라져요\n한번 삭제된 정보는 복구할 수 없습니다"
        descriptionLabel.textColor = .darkGray2
        descriptionLabel.font = .SpoqaHanSansNeoMedium(size: 13)
        itemView.backgroundColor = .textFieldBackgroundColor
        itemView.layer.cornerRadius = 3
        itemLabel.text = "• 그동안 작성한 글과 댓글, 대댓글\n• 나의 북마크, 좋아요"
        itemLabel.textColor = .darkGray1
        itemLabel.font = .SpoqaHanSansNeoRegular(size: 15)
        withdrawalButton.setTitle("네, 탈퇴할래요", for: .normal)
        withdrawalButton.setTitleColor(.primary, for: .normal)
        withdrawalButton.backgroundColor = .white
        withdrawalButton.layer.borderWidth = 1
        withdrawalButton.layer.borderColor = UIColor.primary.cgColor
        withdrawalButton.titleLabel?.font = .SpoqaHanSansNeoBold(size: 17)
        withdrawalButton.layer.cornerRadius = 4
    }
}

// MARK: - Bindings()
extension WithdrawalVC {
    func bindUI() {
        withdrawalButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.withdrawalVM.tryWithdrawal()
            })
            .disposed(by: disposeBag)
    }
    
    func bindVM() {
        withdrawalVM.withdrawalSuccess
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.showSignInVC()
            })
            .disposed(by: disposeBag)
        
        withdrawalVM.apiError
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.showConfirmAlert(with: .networkError, alertMessage: "회원탈퇴에 실패했습니다", style: .default)
            })
            .disposed(by: disposeBag)
    }
}

extension WithdrawalVC {
    func showSignInVC() {
        guard let signInVC = ViewControllerFactory.viewController(for: .signIn) as? SignInVC,
                let ad = UIApplication.shared.delegate as? AppDelegate else { return }
        
        self.dismiss(animated: true) {
            ad.window?.rootViewController = signInVC
            signInVC.setToastViewPosition()
            signInVC.showToastView(alertType: .withdrawal)
        }
    }
}
