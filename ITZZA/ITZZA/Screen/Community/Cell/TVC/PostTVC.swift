//
//  postTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import UIKit
import Kingfisher
import RxSwift

class PostTVC: UITableViewCell {
    @IBOutlet weak var headerView: ProfileHeaderView!
    @IBOutlet weak var footerView: PostButtonsView!
    @IBOutlet weak var postContentView: PostContentView!
    @IBOutlet weak var imageCnt: UILabel!
    @IBOutlet weak var imageCntView: UIStackView!
    
    let bag = DisposeBag()
    var communityTypes = CommunityType.allCases
    
    let cellSpace = UIEdgeInsets(top: 0.0,
                                 left: 0.0,
                                 bottom: 10.0,
                                 right: 0.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setViewBackgroundColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: cellSpace)
    }

}

//MARK: - Custom Methods
extension PostTVC {
    func setViewBackgroundColor() {
        backgroundColor = .clear
        
        headerView.backgroundColor = .clear
        footerView.backgroundColor = .clear
        
        contentView.backgroundColor = .white
    }

    func configureCell(with post: PostModel) {
        headerView.profileImg.kf.setImage(with: post.profileImgURL,
                                          placeholder: UIImage(named: "Null_Comment"),
                                          options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .cacheOriginalImage
                                          ])
        headerView.userName.text = post.nickname
        headerView.createAt.text = post.createdAt
        
        headerView.category.text = communityTypes[post.categoryId!].description
        
        postContentView.title.text = post.postTitle
        postContentView.contents.text = post.postContent
        
        if post.imageCnt == 0 {
            imageCntView.isHidden = true
        } else {
            imageCnt.text = "+" + String(post.imageCnt!)
        }
        
        footerView.boardId = post.boardId
        footerView.likeCnt.text = String(describing: post.likeCnt!)
        footerView.commentCnt.text = String(describing: post.commentCnt!)
        
        footerView.likeButton.isSelected = post.likeStatus ?? false
        footerView.bookmarkButton.isSelected = post.bookmarkStatus ?? false
        footerView.likeButton.setImageToggle(post.likeStatus ?? false, UIImage(named: "Heart")!, UIImage(named: "Heart_selected")!)
        footerView.bookmarkButton.setImageToggle(post.bookmarkStatus ?? false, UIImage(named: "Bookmark")!, UIImage(named: "Bookmark_selected")!)
    }
}
