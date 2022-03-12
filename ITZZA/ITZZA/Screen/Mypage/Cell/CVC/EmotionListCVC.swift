//
//  EmotionListCVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/12.
//

import UIKit

class EmotionListCVC: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
}

extension EmotionListCVC {
    func setTitleColor() {
        switch title.text {
        case Emoji.angry.name,
            Emoji.comfy.name,
            Emoji.lonely.name:
            title.textColor = .white
        default:
            title.textColor = .darkGray6
        }
    }
}
