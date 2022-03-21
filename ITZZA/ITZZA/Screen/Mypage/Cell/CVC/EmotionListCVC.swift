//
//  EmotionListCVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/12.
//

import UIKit

class EmotionListCVC: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor()
    }
}

extension EmotionListCVC {
    private func setTitleColor() {
        title.textColor = .white
    }
}
