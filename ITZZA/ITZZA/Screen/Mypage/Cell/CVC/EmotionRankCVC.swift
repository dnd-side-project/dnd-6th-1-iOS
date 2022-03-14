//
//  EmotionRankCVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/12.
//

import UIKit
import SnapKit

class EmotionRankCVC: UICollectionViewCell {
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var emotionImage: UIImageView!
    @IBOutlet weak var emotionName: UILabel!
    @IBOutlet weak var changeCountImage: UIImageView!
    @IBOutlet weak var changeCount: UILabel!
    @IBOutlet weak var totalEmotionCount: UILabel!
    @IBOutlet weak var seperatorBar: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContentView()
        configureFont()
        configureTextColor(with: .darkGray6)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension EmotionRankCVC {
    private func configureContentView() {
        backgroundColor = .white
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        
        layer.cornerRadius = 4
    }
    
    private func configureFont() {
        rank.font = .SpoqaHanSansNeoMedium(size: 11)
        emotionName.font = .SpoqaHanSansNeoMedium(size: 13)
        changeCount.font = .SpoqaHanSansNeoBold(size: 12)
        totalEmotionCount.font = .SpoqaHanSansNeoMedium(size: 13)
    }
    
    private func configureTextColor(with color: UIColor) {
        rank.textColor = color
        emotionName.textColor = color
        totalEmotionCount.textColor = color
    }
    
    private func setFirstRankCell(_ category: Int) {
        backgroundColor = Emoji.allCases[category - 1].color
        configureTextColor(with: .white)
        
        rank.text = ""
        
        emotionImage.layer.cornerRadius = emotionImage.frame.width / 2
        emotionImage.layer.borderWidth = 1
        emotionImage.layer.borderColor = UIColor.lightGray1.cgColor
        emotionImage.backgroundColor = .lightGray1
        
        changeCount.textColor = .white
        changeCountImage.tintColor = .white
        seperatorBar.backgroundColor = .white
    }
    
    func configureCell(_ report: ReportEmotionModel) {
        setChangedRank(report.rankChange)
        rank.text = "\(report.rank)등"
        emotionName.text = Emoji.allCases[report.category - 1].name
        emotionImage.image = Emoji.allCases[report.category - 1].StickerImage
        totalEmotionCount.text = "총 \(report.cnt)번"
        
        if report.rank == 1 {
            setFirstRankCell(report.category)
            addFirstStiker()
        }
    }
    
    private func addFirstStiker() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MVP")
        
        contentView.superview?.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(35)
            $0.leading.equalTo(contentView.snp.leading).offset(-10)
            $0.top.equalTo(contentView.snp.top).offset(-10)
        }
    }
    
    private func setChangedRank(_ rankChange: Int) {
        if rankChange < 0 {
            changeCount.text = "\(rankChange * -1)"
            changeCount.textColor = .seconLonely
            changeCountImage.image = UIImage(systemName: "arrowtriangle.down.fill")
            changeCountImage.tintColor = .seconLonely
        } else if rankChange > 0 {
            changeCount.text = "\(rankChange)"
            changeCount.textColor = .seconAngry
            changeCountImage.image = UIImage(systemName: "arrowtriangle.up.fill")
            changeCountImage.tintColor = .seconAngry
        } else {
            changeCount.text = "\(rankChange)"
            changeCount.textColor = .lightGray6
            changeCountImage.image = UIImage(systemName: "minus")
            changeCountImage.tintColor = .lightGray6
        }
    }
}
