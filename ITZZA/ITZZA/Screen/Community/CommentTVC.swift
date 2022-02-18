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
        configureText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCommentContent() {
        commentContent.setAllMarginToZero()
        commentContent.setTextViewToViewer()
    }
    
    private func configureText() {
        userName.textColor = .darkGray6
        userName.font = UIFont.SpoqaHanSansNeoMedium(size: 13)
        
        commentContent.textColor = .darkGray3
        commentContent.font = UIFont.SpoqaHanSansNeoRegular(size: 12)
        
        createAt.textColor = .lightGray6
        createAt.font = UIFont.SpoqaHanSansNeoRegular(size: 10)
        
        createCommentButton.setTitle("답글 달기", for: .normal)
        createCommentButton.titleLabel?.font = UIFont.SpoqaHanSansNeoRegular(size: 10)
        createCommentButton.tintColor = .lightGray6
    }
}
