//
//  PostContentTableViewHeader.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/08.
//

import UIKit
import Kingfisher
import SnapKit

class PostContentTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var headerView: ProfileHeaderView!
    @IBOutlet weak var footerView: PostButtonsView!
    @IBOutlet weak var postContentView: PostContentView!
    @IBOutlet weak var postButtonViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    let communityTypes = CommunityType.allCases
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.postContentTableViewHeader) else { return }
        self.addSubview(view)

        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureContents(with post: PostModel) {
        headerView.profileImg.kf.setImage(with: post.profileImgURL,
                                          placeholder: UIImage(systemName: "person.circle"),
                                          options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .cacheOriginalImage
                                          ])
        headerView.userName.text = post.nickname
        headerView.createAt.text = post.createdAt
        headerView.category.text = communityTypes[post.categoryId!].description
        
        postContentView.title.text = post.postTitle
        postContentView.contents.text = post.postContent

        imageScrollView.image = post.postImages ?? []
        imageScrollView.configurePost()
        
        footerView.boardId = post.boardId
        footerView.likeCnt.text = String(describing: post.likeCnt ?? 0)
        footerView.commentCnt.text = String(describing: post.commentCnt ?? 0)
        
        footerView.likeButton.isSelected = post.likeStatus ?? false
        footerView.bookmarkButton.isSelected = post.bookmarkStatus ?? false
        footerView.likeButton.setImageToggle(post.likeStatus ?? false, UIImage(named: "Heart")!, UIImage(named: "Heart_selected")!)
        footerView.bookmarkButton.setImageToggle(post.bookmarkStatus ?? false, UIImage(named: "Bookmark")!, UIImage(named: "Bookmark_selected")!)
    }
    
    func setPostButtonViewTopSpace() {
        if imageScrollView.image.count == 0 {
            postButtonViewTopSpace.constant = 0
        } else {
            postButtonViewTopSpace.constant = 40
        }
    }
}
