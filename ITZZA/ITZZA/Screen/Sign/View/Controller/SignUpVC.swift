//
//  SignUpVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import CoreMedia
import SnapKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var askingSignInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    var emojiImage = UIImageView()
    var bubbleView = UIView()
    var tipView = UIView()
    var bubbleLabel = UILabel()
    let indicatorView = UIActivityIndicatorView()
    
    let emailView = EmailView()
    let passwordView = PasswordView()
    let nicknameView = NicknameView()
    let agreementView = AgreementView()
    var fill: Float = 0.0
    var disposeBag = DisposeBag()
    let signUpVM = SignUpVM()
    var scrollTarget = 0.0
    var emojiLeadingConstraint: Constraint!
    var bubbleLeadingContraint: Constraint!
    var tipLeadingContraint: Constraint!
    let halfOfEmojiWidth: CGFloat = 15
    let halfOfBubble: CGFloat = 45
    let halfOfTip: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUIValue()
        recognizeTapInScrollView()
        setStackView()
        bindUI()
        createEmojiAndBubble()
        coloringTipView(color: UIColor.orange.cgColor)
        bindVM()
        fillProgressBar()
    }
}

// MARK:- Change UI
extension SignUpVC {
    func setInitialUIValue() {
        titleLabel.textColor = .darkGray6
        titleLabel.font = .SpoqaHanSansNeoBold(size: 22)
        titleLabel.text = "회원가입"
        previousButton.layer.borderWidth = 1.0
        previousButton.layer.borderColor = UIColor.primary.cgColor
        previousButton.layer.cornerRadius = 5
        previousButton.setTitleColor(.primary, for: .normal)
        previousButton.titleLabel?.font = .SpoqaHanSansNeoBold(size: 17)
        nextButton.layer.cornerRadius = 5
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = .SpoqaHanSansNeoBold(size: 17)
        nextButton.backgroundColor = .lightGray5
        bubbleView.layer.cornerRadius = 5
        scrollView.isPagingEnabled = false
        askingSignInButton.setTitleColor(.darkGray2, for: .normal)
        askingSignInButton.titleLabel?.font = .SpoqaHanSansNeoRegular(size: 12)
        signInButton.setTitleColor(.darkGray2, for: .normal)
        signInButton.titleLabel?.font = .SpoqaHanSansNeoBold(size: 12)
        signInButton.setUnderline()
        bubbleLabel.font = .SpoqaHanSansNeoRegular(size: 10)
    }
    
    func recognizeTapInScrollView() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func createEmojiAndBubble() {
        view.addSubview(emojiImage)
        view.addSubview(bubbleView)
        bubbleView.addSubview(bubbleLabel)
        view.addSubview(tipView)
        
        bubbleLabel.frame = CGRect(x: 7, y: 3, width: 74, height: 21)
        bubbleLabel.textColor = .white
        bubbleLabel.font = UIFont.SpoqaHanSansNeoRegular(size: 10)
        bubbleLabel.textAlignment = .center
        
        emojiImage.snp.makeConstraints {
            $0.centerY.equalTo(progressBar)
            emojiLeadingConstraint = $0.leading.equalTo(progressBar).constraint
        }
        bubbleView.snp.makeConstraints {
            $0.width.equalTo(89)
            $0.height.equalTo(26)
            $0.centerY.equalTo(progressBar).offset(-37)
            bubbleLeadingContraint = $0.leading.equalTo(progressBar).constraint
        }
        tipView.snp.makeConstraints {
            $0.width.equalTo(8)
            $0.height.equalTo(8)
            $0.centerY.equalTo(progressBar).offset(-21)
            tipLeadingContraint = $0.leading.equalTo(progressBar).constraint
        }
    }
    
    func coloringTipView(color: CGColor) {
        view.layoutIfNeeded()
        let width = tipView.frame.size.width
        let height = tipView.frame.size.height
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width/2, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = color

        tipView.layer.insertSublayer(shape, at: 0)
    }
    
    func moveBubbleLocation(_ idx: CGFloat, _ isLast: Bool) {
        if isLast {
            bubbleLeadingContraint.update(offset: progressBar.frame.width * idx - halfOfBubble - 40)
            tipLeadingContraint.update(offset: progressBar.frame.width * idx - halfOfTip - 7)
        } else {
            bubbleLeadingContraint.update(offset: progressBar.frame.width * idx - halfOfBubble)
            tipLeadingContraint.update(offset: progressBar.frame.width * idx - halfOfTip)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func changeBubbleInfo(to color: UIColor, _ text: String) {
        bubbleView.backgroundColor = color
        (tipView.layer.sublayers?.last as! CAShapeLayer).fillColor = color.cgColor
        bubbleLabel.text = text
    }
    
    func moveAndChangeEmoji(to icon: UIImage, _ idx: CGFloat, _ isLast: Bool) {
        emojiImage.image = icon
        
        if isLast {
            emojiLeadingConstraint.update(offset: progressBar.frame.width * idx - halfOfEmojiWidth - 5)
        } else {
            emojiLeadingConstraint.update(offset: progressBar.frame.width * idx - halfOfEmojiWidth)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setStackView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: previousButton.topAnchor, constant: -20),
        ])
        
        emailView.emailTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        let signUpStackView = UIStackView(arrangedSubviews: [emailView, passwordView, nicknameView, agreementView])
        
        signUpStackView.axis = .horizontal
        signUpStackView.alignment = .fill
        signUpStackView.distribution = .fill
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(signUpStackView)
        
        NSLayoutConstraint.activate([
            signUpStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            signUpStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            signUpStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            signUpStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        signUpStackView.arrangedSubviews.forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }
    }
    
    func scrollToNextView() {
        var point = scrollView.contentOffset
        scrollTarget += scrollView.frame.width
        point.x = scrollTarget
        scrollView.setContentOffset(point, animated: true)
    }
    
    func scrollToPreviousView() {
        var point = scrollView.contentOffset
        scrollTarget -= scrollView.frame.width
        point.x = scrollTarget
        scrollView.setContentOffset(point, animated: true)
    }
    
    func changeNextButton(_ isValid: Bool) {
        if isValid {
            nextButton.backgroundColor = .primary
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = .lightGray5
            nextButton.isEnabled = false
        }
    }
    
    func changeNextToComplete(_ isValid: Bool) {
        if isValid {
            nextButton.setTitle("회원가입", for: .normal)
        } else {
            nextButton.setTitle("다음단계", for: .normal)
        }
    }
    
    func startSignUpProcess() {
        let email = emailView.emailTextField.text!
        let password = passwordView.confirmPasswordTextField.text!
        let nickname = nicknameView.nicknameTextField.text!
        signUpVM.trySignUp(with: email, password, nickname)
    }
    
    func checkButtonTitle(_ buttonTitle: String) {
        if buttonTitle == "다음단계" {
            fillProgressBar()
            scrollToNextView()
            changeNextButton(false)
        } else {
            startSignUpProcess()
        }
    }
}

// MARK: - ProgressBar Methods
extension SignUpVC {
    func fillProgressBar() {
        if fill < 1 {
            fill += 0.25
        }
        UIView.animate(withDuration: 0.3) {
            self.progressBar.setProgress(self.fill, animated: true)
        }
    }
    
    func withdrawProgressBar() {
        if fill > 0 {
            fill -= 0.25
        }
        UIView.animate(withDuration: 0.3) {
            self.progressBar.setProgress(self.fill, animated: true)
        }
    }
}

// MARK: - Bindings
extension SignUpVC {
    func bindUI() {
        previousButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.withdrawProgressBar()
                self.scrollToPreviousView()
                self.changeNextButton(true)
                self.changeNextToComplete(false)
            })
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.signUpVM.decreasePageCount()
                self.signUpVM.checkGoToMain()
                self.nicknameView.checkDupliacteAgain()
                self.agreementView.setAsOutlineStatusFromPrevious()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.checkButtonTitle(self.nextButton.currentTitle ?? "다음단계")
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.signUpVM.increasePageCount()
            })
            .disposed(by: disposeBag)
        
        signInButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        emailView.isValidEmail.asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.changeNextButton(isValid)
            })
            .disposed(by: disposeBag)
        
        passwordView.isValidPassword.asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.changeNextButton(isValid)
            })
            .disposed(by: disposeBag)
        
        nicknameView.isValidNickname.asDriver()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.changeNextButton(isValid)
            })
            .disposed(by: disposeBag)
        
        agreementView.isValidAgreement.asDriver()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.changeNextButton(isValid)
                self.changeNextToComplete(isValid)
            })
            .disposed(by: disposeBag)
    }
    
    func bindVM() {
        signUpVM.previousButtonTitle.asDriver()
            .drive(previousButton.rx.title())
            .disposed(by: disposeBag)
        
        signUpVM.goToMain.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        signUpVM.decideProgressBarColor.asDriver()
            .drive(onNext: { [weak self] color in
                guard let self = self else { return }
                self.progressBar.tintColor = color
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeAngryImage.asDriver()
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveAndChangeEmoji(to: .coloredAngryEmoji, 0.25, false)
                self.moveBubbleLocation(0.25, false)
                self.changeBubbleInfo(to: .seconAngry, Literal.first.description)
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeConfuseImage.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveAndChangeEmoji(to: .coloredConfuseEmoji, 0.5, false)
                self.moveBubbleLocation(0.5, false)
                self.changeBubbleInfo(to: .seconConfused, Literal.second.description)
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeSadImage.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveAndChangeEmoji(to: .coloredSadEmoji, 0.75, false)
                self.moveBubbleLocation(0.75, false)
                self.changeBubbleInfo(to: .seconSorrow, Literal.third.description)
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeComfyImage.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveAndChangeEmoji(to: .coloredComfyEmoji, 1, true)
                self.moveBubbleLocation(1, true)
                self.changeBubbleInfo(to: .seconRelaxed, Literal.fourth.description)
            })
            .disposed(by: disposeBag)
        
        signUpVM.signUpSuccess.asDriver(onErrorJustReturn: "회원가입이 완료되었습니다")
            .drive(onNext: { [weak self] response in
                guard let self = self else { return }
                guard let signInVC = self.presentingViewController as? SignInVC else { return }
                
                self.dismiss(animated: true) {
                    signInVC.setToastViewPosition()
                    signInVC.showToastView(alertType: .signUp)
                }
            })
            .disposed(by: disposeBag)
        
        signUpVM.signUpFail.asDriver(onErrorJustReturn: "닉네임 중복확인을 다시 한 번 해주세요")
            .drive(onNext: { [weak self] response in
                guard let self = self else { return }
                self.showConfirmAlert(with: .signUpError, alertMessage: response, style: .default)
            })
            .disposed(by: disposeBag)
        
        signUpVM.serverError.asDriver(onErrorJustReturn: .unknown)
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showConfirmAlert(with: .signUpError, alertMessage: error.description, style: .default)
            })
            .disposed(by: disposeBag)
    }
}

