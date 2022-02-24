//
//  EmojiAnimationView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/24.
//

import UIKit
import Lottie
import SnapKit

class EmojiAnimationView: UIView {
    
    var animationView = AnimationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        setAnimationView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        setAnimationView()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.emojiAnimationView)
    }
}

// MARK: - Change UI
extension EmojiAnimationView {
    private func setAnimationView() {
        self.addSubview(animationView)
 
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureLottieAnimation(with categoryId: Int) {
        switch categoryId {
        case 0:
            return
        case 1:
            animationView = .init(name: "Animation_Angry")
        case 2:
            animationView = .init(name: "Animation_Comfy")
        case 3:
            animationView = .init(name: "Animation_Confuse")
        case 4:
            animationView = .init(name: "Animation_Sad")
        case 5:
            animationView = .init(name: "Animation_Lonely")
        default:
            animationView = .init(name: "Animation_Angry")
        }
        
        animationView.clipsToBounds = false
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        setAnimationView()
    }
}
