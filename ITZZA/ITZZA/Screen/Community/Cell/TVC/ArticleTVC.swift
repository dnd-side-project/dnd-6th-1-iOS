//
//  articleTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import UIKit

class ArticleTVC: UITableViewCell {
    @IBOutlet weak var headerView: ProfileHeaderView!
    @IBOutlet weak var footerView: PostButtonsView!
    @IBOutlet weak var contents: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contents.isScrollEnabled = false
        contents.isEditable = false
        contents.isSelectable = false
        contents.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
