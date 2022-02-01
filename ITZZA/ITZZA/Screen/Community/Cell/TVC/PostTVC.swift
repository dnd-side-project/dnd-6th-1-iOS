//
//  postTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import UIKit

class PostTVC: UITableViewCell {
    @IBOutlet weak var headerView: ProfileHeaderView!
    @IBOutlet weak var footerView: PostButtonsView!
    @IBOutlet weak var contents: UITextView!
    
    let cellSpace = UIEdgeInsets(top: 0.0,
                                 left: 0.0,
                                 bottom: 5.0,
                                 right: 0.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contents.isScrollEnabled = false
        contents.isEditable = false
        contents.isSelectable = false
        contents.backgroundColor = .clear
        
        headerView.backgroundColor = .clear
        footerView.backgroundColor = .clear
        
        contentView.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: cellSpace)
    }

}
