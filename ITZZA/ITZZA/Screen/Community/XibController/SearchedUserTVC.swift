//
//  SearchedUserTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/23.
//

import UIKit
import Kingfisher

class SearchedUserTVC: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var userId:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}
extension SearchedUserTVC {
    func configureCell(_ post: PostModel) {
        profileImg.kf.setImage(with: URL(string: post.profileImage!),
                                          placeholder: UIImage(named: "Null_Comment"),
                                          options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .cacheOriginalImage
                                          ])
        userName.text = post.nickname
        userId = post.userId
    }
}
