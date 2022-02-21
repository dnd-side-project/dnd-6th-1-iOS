//
//  PostDetailVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit
import RxSwift
import RxDataSources

class PostDetailVC: UIViewController {
    @IBOutlet weak var commentListTV: UITableView!
    
    let bag = DisposeBag()
    var post = PostModel()
    var boardId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPost()
    }
}

//MARK: - Custom Methods
extension PostDetailVC {
    func setPost() {
        PostManager().getPostDetail(boardId ?? 0) { posts in
            if let posts = posts {
                self.post = posts
                DispatchQueue.main.async {
                    self.setCommentListTV()
                }
            }
        }
    }
    
    func setCommentListTV() {
        commentListTV.dataSource = self
        commentListTV.delegate = self
        commentListTV.backgroundColor = .lightGray1
        commentListTV.separatorStyle = .none
        
        register()
        bindPostListTVItemSelected()
    }
    
    func register(){
        commentListTV.register(UINib(nibName: Identifiers.commentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.commentTVC)
        commentListTV.register(PostContentTableViewHeader.self, forHeaderFooterViewReuseIdentifier: Identifiers.postContentTableViewHeader)
    }
    
    func bindPostListTVItemSelected() {
        commentListTV.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if indexPath.row != 0 {
                    print(indexPath.row, "댓글 눌림")
                }
            })
            .disposed(by: bag)
    }
}

extension PostDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identifiers.postContentTableViewHeader) as? PostContentTableViewHeader else { return nil }
        headerView.configureContents(with: post)
        headerView.setPostButtonViewTopSpace()
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if post.commentCnt == 0 {
            return 1
        } else {
            return (post.comments?.count ?? 0) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if post.commentCnt == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.noneCommentCell, for: indexPath)
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = .clear
            
            return cell
            
        } else {
            if indexPath == [0,0] {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentCountCell, for: indexPath) as? CommentCountTVC else { return UITableViewCell() }
                cell.setCommentCount(self.post.commentCnt ?? 0)
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = .clear
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTVC, for: indexPath) as? CommentTVC else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.configureCell(self.post.comments![indexPath.row - 1].comment!)
                return cell
            }
        }
    }
}
