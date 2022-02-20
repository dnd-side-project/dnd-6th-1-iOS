//
//  EmotionCVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/20.
//

import UIKit

class EmotionCVC: UICollectionViewCell {
    
    @IBOutlet weak var emojiBackground: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with image: UIImage, _ label: String) {
        imageView.image = image
        emojiLabel.text = label
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "EmotionCVC", bundle: nil)
    }
}
