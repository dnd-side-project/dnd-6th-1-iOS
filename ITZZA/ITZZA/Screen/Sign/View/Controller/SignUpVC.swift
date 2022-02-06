//
//  SignUpVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    let mainTitles = ["이메일 입력", "비밀번호 입력", "닉네임 입력", "약관 동의"]
    var fill: Float = 0.0
    var fillTarget: Float = 0.0
    var timer: Timer?
    var disposeBag = DisposeBag()
    let signUpVM = SignUpVM()
    
    override func viewDidLoad() {
        setInitialUIValue()
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
    }
}
