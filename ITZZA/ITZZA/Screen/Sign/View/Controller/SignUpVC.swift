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
import SwiftUI

class SignUpVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    var emojiImage = UIImageView()
    var bubbleView = UIView()
    var tipView = UIView()
    var bubbleLabel = UILabel()
    
    let mainTitles = ["이메일 입력", "비밀번호 입력", "닉네임 입력", "약관 동의"]
    var fill: Float = 0.0
    var fillTarget: Float = 0.0
    var timer: Timer?
    var disposeBag = DisposeBag()
    let signUpVM = SignUpVM()
    var scrollTarget = 0.0
    
    override func viewDidLoad() {
        setInitialUIValue()
        recognizeTapInScrollView()
        setStackView()
        bindUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createEmojiAndBubble()
        bindVM()
        fillProgressBar()
    }
    
}

// MARK:- Change UI
extension SignUpVC {
    func setInitialUIValue() {
        titleLabel.text = mainTitles[0]
        progressBar.tintColor = .orange
        progressBar.setProgress(0.0, animated: true)
        previousButton.layer.borderWidth = 1.0
        previousButton.layer.borderColor = UIColor.black.cgColor
        previousButton.layer.cornerRadius = 5
        nextButton.layer.cornerRadius = 5
        bubbleView.layer.cornerRadius = 5
        scrollView.isPagingEnabled = false
    }
    
    func createEmojiAndBubble() {
        let point = progressBar.frame
        
        emojiImage.image = .coloredAngryEmoji
        emojiImage.frame = CGRect(x: point.width * 0.25,
                                 y: point.origin.y - 15,
                                 width: 30, height: 30)
        
        bubbleView.frame = CGRect(x: point.width * 0.25 - 30,
                              y: point.origin.y - 53,
                              width: 89,
                              height: 26)
        
        bubbleLabel.frame = CGRect(x: 7, y: 3, width: 74, height: 21)
        bubbleLabel.textColor = .white
        bubbleLabel.font = UIFont.SFProDisplayRegular(size: 10)
        bubbleLabel.textAlignment = .center
        
        tipView.frame = CGRect(x: point.width * 0.25 + 11,
                               y: point.origin.y - 27,
                               width: 8,
                               height: 8)

        createBubbleTipView(color: UIColor.orange.cgColor)
        bubbleView.addSubview(bubbleLabel)
        view.addSubview(emojiImage)
        view.addSubview(bubbleView)
        view.addSubview(tipView)
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
    
    func setStackView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: previousButton.topAnchor, constant: -20),
        ])
        
        print(scrollView.frame.width)
        
        let emailView = EmailView()
        let passwordView = PasswordView()
        let nicknameView = NicknameView()
        let agreementView = AgreementView()
        
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
    
    func createBubbleTipView(color: CGColor) {
        let width = tipView.frame.size.width
        let height = tipView.frame.size.height
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: 0))  // 시작점
        path.addLine(to: CGPoint(x: width/2, y: height)) // 라인 1
        path.addLine(to: CGPoint(x: width, y: 0))   // 라인 2
        path.addLine(to: CGPoint(x: 0, y: 0))   // 라인 3 삼각형 완성!

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = color

        tipView.layer.insertSublayer(shape, at: 0)
    }
    
    func moveBubbleLocation(_ idx: CGFloat, _ isLast: Bool) {
        let bubbleWidth = bubbleView.frame.width
        let bubbleHeight = bubbleView.frame.size.height
        let tipWidth = tipView.frame.width
        let tipHeigt = tipView.frame.height
        let progressWidth = progressBar.frame.size.width * idx
        let progressY = progressBar.frame.origin.y
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            
            if isLast {
                self.bubbleView.frame = CGRect(x: progressWidth - bubbleWidth + 15,
                                               y: progressY - 53,
                                               width: bubbleWidth,
                                               height: bubbleHeight)
                self.tipView.frame = CGRect(x: progressWidth - (self.tipView.frame.size.width) / 2 + 5,
                                            y: progressY - 27,
                                            width: tipWidth,
                                            height: tipHeigt)
            } else {
                self.bubbleView.frame = CGRect(x: progressWidth - (bubbleWidth / 2) + 15,
                                               y: progressY - 53,
                                               width: bubbleWidth,
                                               height: bubbleHeight)
                self.tipView.frame = CGRect(x: progressWidth - (self.tipView.frame.size.width) / 2 + 15,
                                            y: progressY - 27,
                                            width: tipWidth,
                                            height: tipHeigt)
            }
        }, completion: nil)
    }
    
    func changeBubbleInfo(to color: UIColor, _ text: String) {
        bubbleView.backgroundColor = color
        (tipView.layer.sublayers?.last as! CAShapeLayer).fillColor = color.cgColor
        bubbleLabel.text = text
    }
    
    func moveAndChangeEmoji(to icon: UIImage, _ idx: CGFloat, _ isLast: Bool) {
        emojiImage.image = icon
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            
            if isLast {
                self.emojiImage.frame = CGRect(x: self.progressBar.frame.size.width * idx - 10,
                                              y: self.progressBar.frame.origin.y - 15,
                                              width: self.emojiImage.frame.size.width,
                                              height: self.emojiImage.frame.size.height)
            } else {
                self.emojiImage.frame = CGRect(x: self.progressBar.frame.size.width * idx,
                                              y: self.progressBar.frame.origin.y - 15,
                                              width: self.emojiImage.frame.size.width,
                                              height: self.emojiImage.frame.size.height)
            }
        }, completion: nil)
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
}

// MARK: - ProgressBar Methods
extension SignUpVC {
    func fillProgressBar() {
        if fillTarget < 1 {
            fillTarget += 0.25
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.075,
                                         target: self,
                                         selector: #selector(increaseProgressBar),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    func withdrawProgressBar() {
        if fillTarget > 0 {
            fillTarget -= 0.25
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.075,
                                         target: self,
                                         selector: #selector(decreaseProgressBar),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc func increaseProgressBar() {
        if fill < 1 {
            fill += 0.05
            progressBar.setProgress(fill, animated: true)
            if fill >= fillTarget {
                timer?.invalidate()
            }
        } else {
            timer?.invalidate()
        }
    }
    
    @objc func decreaseProgressBar() {
        if fill > 0 {
            fill -= 0.05
            progressBar.setProgress(fill, animated: true)
            if fill <= fillTarget {
                timer?.invalidate()
            }
        } else {
            timer?.invalidate()
        }
    }
}

// MARK: - Bind UI Element
extension SignUpVC {
    func bindUI() {
        previousButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.withdrawProgressBar()
                self.scrollToPreviousView()
            })
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.signUpVM.decreasePageCount()
                self.signUpVM.checkGoToMain()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.fillProgressBar()
                self.scrollToNextView()
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
    }
    
    func bindVM() {
        signUpVM.previousButtonTitle.asDriver()
            .drive(previousButton.rx.title())
            .disposed(by: disposeBag)
        
        signUpVM.goToMain.asDriver()
            .skip(1)
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
                self.changeBubbleInfo(to: .orange, "시작이 반이다")
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeConfuseImage.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveAndChangeEmoji(to: .coloredConfuseEmoji, 0.5, false)
                self.moveBubbleLocation(0.5, false)
                self.changeBubbleInfo(to: .purple, "벌써 2단계!")
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeSadImage.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveAndChangeEmoji(to: .coloredSadEmoji, 0.75, false)
                self.moveBubbleLocation(0.75, false)
                self.changeBubbleInfo(to: .blue, "거의 다 왔어요!")
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeComfyImage.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveAndChangeEmoji(to: .coloredComfyEmoji, 1, true)
                self.moveBubbleLocation(1, true)
                self.changeBubbleInfo(to: .yellow, "이제 마지막!")
            })
            .disposed(by: disposeBag)
    }
}

