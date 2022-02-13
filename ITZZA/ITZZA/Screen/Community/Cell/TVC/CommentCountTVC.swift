//
//  CommentCountTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/07.
//

import UIKit

class CommentCountTVC: UITableViewCell {
    @IBOutlet weak var commentCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        contentView.backgroundColor = .white
    }

    func setCommentCount(_ cnt: Int) {
        commentCount.text = "총 \(cnt)개의 댓글"
    }
}
