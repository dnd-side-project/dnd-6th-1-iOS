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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MypageCVC", bundle: nil)
    }
    
    func configure(_ index: Int, _ info: MypageModel) {
        switch index {
        case 0:
            writeType.text = "내가 쓴 글"
            numberOfWrite.text = String(info.writeCnt ?? 0)
        case 1:
            writeType.text = "북마크"
            numberOfWrite.text = String(info.bookmarkCnt ?? 0)
        case 2:
            writeType.text = "댓글"
            numberOfWrite.text = String(info.commentCnt ?? 0)
        default:
            writeType.text = "내가 쓴 글"
            numberOfWrite.text = String(info.writeCnt ?? 0)
        }
    }
}
