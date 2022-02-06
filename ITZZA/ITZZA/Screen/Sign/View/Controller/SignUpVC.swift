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

class SignUpVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var angryImage: UIImageView!
    @IBOutlet weak var confuseImage: UIImageView!
    @IBOutlet weak var sadImage: UIImageView!
    @IBOutlet weak var comfyImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var tipView: UIView!
    
    let mainTitles = ["이메일 입력", "비밀번호 입력", "닉네임 입력", "약관 동의"]
    var fill: Float = 0.0
    var fillTarget: Float = 0.0
    var timer: Timer?
    var disposeBag = DisposeBag()
    let signUpVM = SignUpVM()
    
    override func viewDidLoad() {
        setInitialUIValue()
        createBubbleTipView(color: UIColor.orange.cgColor)
        bindUI()
        bindVM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fillProgressBar()
    }
}

// MARK:- Change UI
extension SignUpVC {
    func setInitialUIValue() {
        titleLabel.text = mainTitles[0]
        angryImage.image = .coloredAngryEmoji
        confuseImage.image = .coloredConfuseEmoji
        sadImage.image = .coloredSadEmoji
        comfyImage.image = .coloredComfyEmoji
        progressBar.bringSubviewToFront(angryImage)
        progressBar.tintColor = .orange
        progressBar.setProgress(0.0, animated: true)
        previousButton.layer.borderWidth = 1.0
        previousButton.layer.borderColor = UIColor.black.cgColor
        previousButton.layer.cornerRadius = 5
        nextButton.layer.cornerRadius = 5
        tipView.backgroundColor = .white
    }
    
    func changeImageAlpha(with imageView: UIImageView, _ flag: Bool) {
        imageView.isHidden = flag
        imageView.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            imageView.alpha = 1.0
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
    
    func moveBubbleLocation(to x: CGFloat, y: CGFloat) {
        let width = bubbleView.frame.size.width
        let height = bubbleView.frame.size.height
        bubbleView.frame = CGRect(x: x - 29, y: y - 40, width: width, height: height)
        tipView.frame = CGRect(x: bubbleView.frame.origin.x + 41.0,
                               y: bubbleView.frame.origin.y + 26.0,
                               width: tipView.frame.size.width,
                               height: tipView.frame.size.height)
    }
    
}

// MARK: - ProgressBar Methods
extension SignUpVC {
    func fillProgressBar() {
        if fillTarget < 1 {
            fillTarget += 0.25
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.05,
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
            timer = Timer.scheduledTimer(timeInterval: 0.05,
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
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveBubbleLocation(to: self.angryImage.frame.origin.x, y: self.angryImage.frame.origin.y)
                self.changeImageAlpha(with: self.angryImage, flag)
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeConfuseImage.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveBubbleLocation(to: self.confuseImage.frame.origin.x, y: self.confuseImage.frame.origin.y)
                self.changeImageAlpha(with: self.confuseImage, flag)
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeSadImage.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveBubbleLocation(to: self.sadImage.frame.origin.x, y: self.sadImage.frame.origin.y)
                self.changeImageAlpha(with: self.sadImage, flag)
            })
            .disposed(by: disposeBag)
        
        signUpVM.visualizeComfyImage.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] flag in
                guard let self = self else { return }
                self.moveBubbleLocation(to: self.comfyImage.frame.origin.x, y: self.comfyImage.frame.origin.y)
                self.changeImageAlpha(with: self.comfyImage, flag)
            })
            .disposed(by: disposeBag)
    }
}

