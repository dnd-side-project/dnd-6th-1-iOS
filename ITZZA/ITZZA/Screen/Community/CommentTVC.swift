//
//  CommentTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit

class CommentTVC: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentContent: UITextView!
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var createCommentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCommentContent()
        setCreateCommentButton()
        setCreateAtLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCommentContent() {
        commentContent.setAllMarginToZero()
        commentContent.setTextViewToViewer()
    }
    
    func setCreateCommentButton() {
        createCommentButton.setTitle("답글 달기", for: .normal)
        createCommentButton.titleLabel?.font = UIFont.SFProDisplayRegular(size: 10)
        createCommentButton.tintColor = .systemGray
    }
    
    func setCreateAtLabel() {
        createAt.textColor = .systemGray
    }
}
