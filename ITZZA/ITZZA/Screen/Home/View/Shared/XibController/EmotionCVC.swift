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
    
    static func nib() -> UINib {
        return UINib(nibName: "EmotionCVC", bundle: nil)
    }
    
    func update(_ name: String, _ status: Bool, _ label: String) {
        if status {
            let startIndex = name.index(name.startIndex, offsetBy: 3)
            let range = name.index(after: startIndex) ..< name.endIndex
            let color = getColor(name)
            imageView.image = UIImage(named: String(name[range]))
            emojiBackground.backgroundColor = color.0
            emojiLabel.textColor = color.1
        } else {
            imageView.image = UIImage(named: name)
            emojiBackground.backgroundColor = .lightGray1
            emojiLabel.textColor = .lightGray6
        }
        emojiLabel.text = label
    }
    
    func getColor(_ name: String) -> (UIColor, UIColor) {
        switch name {
        case GrayEmoji.angry.rawValue:
            return (UIColor.seconAngryBackground, UIColor.seconAngry)
        case GrayEmoji.comfy.rawValue:
            return (UIColor.seconRelaxedBackground, UIColor.seconRelaxed)
        case GrayEmoji.confuse.rawValue:
            return (UIColor.seconConfusedBackground, UIColor.seconConfused)
        case GrayEmoji.sad.rawValue:
            return (UIColor.seconSorrowBackground, UIColor.seconSorrow)
        case GrayEmoji.lonely.rawValue:
            return (UIColor.seconLonelyBackground, UIColor.seconLonely)
        default:
            return (UIColor.seconAngryBackground, UIColor.seconAngry)
        }
    }
}
