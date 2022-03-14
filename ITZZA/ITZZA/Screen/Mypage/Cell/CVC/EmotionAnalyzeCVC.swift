//
//  EmotionAnalyzeCVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/13.
//

import UIKit
import SnapKit

class EmotionAnalyzeCVC: UICollectionViewCell {

    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var diaryView: UIView!
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var diaryTitle: UILabel!
    @IBOutlet weak var diaryContent: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureDotImage()
        configureFont()
        configureDiaryView()
    }

}

extension EmotionAnalyzeCVC {
    func configureDotImage() {
        dotImage.layer.cornerRadius = dotImage.frame.width / 2
        dotImage.backgroundColor = .white
        dotImage.layer.borderWidth = 2
        dotImage.layer.borderColor = UIColor.seconConfused.cgColor
    }
    
    func configureDiaryView() {
        diaryView.layer.masksToBounds = false
        diaryView.layer.shadowColor = UIColor.black.cgColor
        diaryView.layer.shadowOffset = CGSize(width: 0, height: 2)
        diaryView.layer.shadowOpacity = 0.1

        diaryView.layer.cornerRadius = 4
        
        pointView.layer.cornerRadius = 4
        pointView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func configureFont() {
        day.font = .SpoqaHanSansNeoMedium(size: 13)
        day.textColor = .darkGray2
        
        date.font = .SpoqaHanSansNeoMedium(size: 17)
        date.textColor = .darkGray6
        
        diaryTitle.font = .SpoqaHanSansNeoMedium(size: 12)
        diaryTitle.textColor = .darkGray6
        
        diaryContent.font = .SpoqaHanSansNeoRegular(size: 10)
        diaryContent.textColor = .darkGray1
        
        createdAt.font = .SpoqaHanSansNeoRegular(size: 10)
        createdAt.textColor = .lightGray5
    }
    
    func configureLine() {
        layer.masksToBounds = false
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray5
        contentView.superview?.addSubview(lineView)
        
        lineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(65)
            $0.top.equalTo(dotImage.snp.bottom)
            $0.centerX.equalTo(dotImage.snp.centerX)
        }
    }
}
