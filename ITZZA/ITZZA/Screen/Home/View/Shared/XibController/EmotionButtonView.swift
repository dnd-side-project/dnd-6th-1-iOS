//
//  EmotionButtonView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/17.
//

import UIKit
import RxSwift
import RxCocoa

class EmotionButtonView: UIView {
    
    var disposeBag = DisposeBag()
    @IBOutlet weak var angryButton: UIButton!
    @IBOutlet weak var comfyButton: UIButton!
    @IBOutlet weak var confuseButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var lonelyButton: UIButton!
    
    var emotionButtons: Array<UIButton>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        setInitialUIValue()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        setInitialUIValue()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.emotionButtonView)
    }
}

// MARK: - Change UI
extension EmotionButtonView {
    private func setInitialUIValue() {
        emotionButtons = [angryButton, comfyButton, confuseButton, sadButton, lonelyButton]
    }
    
    func setButtonCornerRadius() {
        if let emotionButtons = emotionButtons {
            emotionButtons.forEach { btn in
                btn.layer.cornerRadius = btn.frame.width / 2
                btn.clipsToBounds = true
            }
        }
    }
    
    func enlargeButtonImage() {
        if let emotionButtons = emotionButtons {
            emotionButtons.forEach { btn in
                //btn.imageView?.contentMode = .scaleAspectFit
            }
        }
    }
}

// MARK: - Bindings
extension EmotionButtonView {
    
}
