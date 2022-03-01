//
//  MypageCVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/26.
//

import UIKit

class MypageCVC: UICollectionViewCell {
    
    @IBOutlet weak var writeType: UILabel!
    @IBOutlet weak var numberOfWrite: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MypageCVC", bundle: nil)
    }
    
    func configure(_ index: Int, _ info: MypageModel) {
        writeType.font = UIFont.SpoqaHanSansNeoMedium(size: 12)
        writeType.textColor = .primary
        numberOfWrite.font = UIFont.SpoqaHanSansNeoBold(size: 17)
        numberOfWrite.textColor = .darkGray4
        
        switch index {
        case 0:
            typeImage.image = UIImage(named: "Notebook")
            writeType.text = "내가 쓴 글"
            numberOfWrite.text = String(info.writeCnt ?? 0)
        case 1:
            typeImage.image = UIImage(named: "Bookmark_Mini")
            writeType.text = "북마크"
            numberOfWrite.text = String(info.bookmarkCnt ?? 0)
        case 2:
            writeType.text = "댓글"
            typeImage.image = UIImage(named: "Chat")
            numberOfWrite.text = String(info.commentCnt ?? 0)
        default:
            typeImage.image = UIImage(named: "Notebook")
            writeType.text = "내가 쓴 글"
            numberOfWrite.text = String(info.writeCnt ?? 0)
        }
    }
}
