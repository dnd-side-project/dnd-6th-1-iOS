//
//  KeywordContentTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/23.
//

import UIKit

class KeywordContentTVC: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var imageCntView: UIStackView!
    @IBOutlet weak var imageCnt: UILabel!
    
    let communityTypes = CommunityType.allCases
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setContentView()
        configureText()
    }
}

extension KeywordContentTVC {
    private func setContentView() {
        selectionStyle = .none
    }
    
    private func configureText() {
        title.textColor = .darkGray3
        nickname.textColor = .lightGray5
        content.textColor = .darkGray2
        createdAt.textColor = .lightGray6
        
        content.setLineBreakMode()
        
        category.textColor = .primary
        category.layer.borderColor = UIColor.primary.cgColor
        category.layer.borderWidth = 0.5
        category.layer.cornerRadius = 4
    }
    
    func configureCell(_ post: PostModel) {
        title.text = post.postTitle
        nickname.text = post.nickname
        content.text = post.postContent
        createdAt.text = post.createdAt
        
        if post.imageCnt == 0 {
            imageCntView.isHidden = true
        } else {
            imageCnt.text = "+" + String(post.imageCnt ?? 0)
        }
        
        category.text = communityTypes[post.categoryId ?? 0].description
    }
}
