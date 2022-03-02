//
//  CommentTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit
import Kingfisher
import RxSwift

class CommentTVC: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentContent: UITextView!
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var createCommentButton: UIButton!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    let bag = DisposeBag()
    
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
        
        writer.textColor = .primary
        writer.font = UIFont.SpoqaHanSansNeoRegular(size: 10)
        writer.text = "글쓴이"
        writer.textAlignment = .center
        writer.layer.borderColor = UIColor.primary.cgColor
        writer.layer.borderWidth = 0.5
        writer.layer.cornerRadius = 4
        
        commentContent.textColor = .darkGray6
        commentContent.font = UIFont.SpoqaHanSansNeoRegular(size: 12)
        
        createAt.textColor = .lightGray6
        createAt.font = UIFont.SpoqaHanSansNeoRegular(size: 10)
        
        createCommentButton.setTitle("답글 달기", for: .normal)
        createCommentButton.titleLabel?.font = UIFont.SpoqaHanSansNeoRegular(size: 10)
        createCommentButton.tintColor = .lightGray6
    }
    
    func didTapMenuButton(_ vc: UIViewController, _ canEdit: Bool) {
        if canEdit {
            menuButton.rx.tap
                .asDriver()
                .drive(onNext: {
                    let menuBottomSheet = MenuBottomSheet()
                    menuBottomSheet.bindButtonAction(.whenEditCommentMenuTapped, .whenDeleteCommentMenuTapped)
                    vc.present(menuBottomSheet, animated: true)
                })
                .disposed(by: bag)
        }
    }
    
    func configureCell(_ comments: CommentModel) {
        profileImg.kf.setImage(with: URL(string: comments.profileImage!),
                               placeholder: UIImage(named: "Null_Comment"),
                               options: [
                                .scaleFactor(UIScreen.main.scale),
                                .cacheOriginalImage
                               ])
        userName.text = comments.nickname
        writer.isHidden = !(comments.writerOrNot ?? false)
        commentContent.text = comments.commentContent
        createAt.text = comments.createdAt
    }
}
