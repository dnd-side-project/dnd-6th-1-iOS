//
//  SignUpVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/04.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var angryView: UIView!
    @IBOutlet weak var confuseView: UIView!
    @IBOutlet weak var sadView: UIView!
    @IBOutlet weak var comfyView: UIView!
    @IBOutlet weak var angryImage: UIImageView!
    @IBOutlet weak var confuseImage: UIImageView!
    @IBOutlet weak var sadImage: UIImageView!
    @IBOutlet weak var comfyImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    let mainTitles = ["이메일 입력", "비밀번호 입력", "닉네임 입력", "약관 동의"]
    
    
    override func viewDidLoad() {
        setInitialUIValue()
    }
}

// MARK:- Set Initial UI Value
extension SignUpVC {
    func setInitialUIValue() {
        titleLabel.text = mainTitles[0]
        angryImage.image = .coloredAngryEmoji
        confuseImage.image = .coloredConfuseEmoji
        sadImage.image = .coloredSadEmoji
        comfyImage.image = .coloredComfyEmoji
    }
    
    func setViewColor(_ index: Int) {
        
    }
}

extension SignUpVC {
    func bindUI() {
        
    }
}
