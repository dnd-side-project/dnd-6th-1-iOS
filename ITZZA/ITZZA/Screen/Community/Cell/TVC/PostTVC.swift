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
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var imageCnt: UILabel!
    @IBOutlet weak var imageCntView: UIStackView!
    
    let bag = DisposeBag()
    
    let cellSpace = UIEdgeInsets(top: 0.0,
                                 left: 0.0,
                                 bottom: 5.0,
                                 right: 0.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setContents()
        setViewBackgroundColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = .clear
        } else {
            UIView.animate(withDuration: 0.7, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.contentView.backgroundColor = .white
            }, completion: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: cellSpace)
    }

}

//MARK: - Custom Methods
extension PostTVC {
    func setContents() {
        contents.isScrollEnabled = false
        contents.isUserInteractionEnabled = false
        contents.backgroundColor = .clear
    }
    
    func setViewBackgroundColor() {
        backgroundColor = .clear
        
        headerView.backgroundColor = .clear
        footerView.backgroundColor = .clear
        
        contentView.backgroundColor = .white
    }

    func configureCell(with post: PostModel) {
        headerView.profileImg.kf.setImage(with: post.profileimgURL,
                                          placeholder: UIImage(systemName: "person.circle"),
                                          options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .cacheOriginalImage
                                          ])
        headerView.userName.text = post.nickName
        headerView.createAt.text = post.createdAt
        
        contentTitle.text = post.postTitle
        contents.text = post.postContent
        
        if post.imageCnt == 0 {
            imageCntView.isHidden = true
        } else {
            imageCnt.text = "+" + String(post.imageCnt!)
        }
        
        footerView.likeCnt.text = String(describing: post.likeCnt!)
        footerView.commentCnt.text = String(describing: post.commentCnt!)
    }
    
    func bindButtonAction() {
        footerView.didTapLikeButton()
        footerView.didTapBookmarkButton()
    }
}
