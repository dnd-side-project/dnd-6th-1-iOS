//
//  CategoryVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CategoryVC: UIViewController {
    @IBOutlet weak var postListTV: UITableView!
    
    let bag = DisposeBag()
    var postListVM: PostListVM!
    var communityType: CommunityType?
    var isNoneData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPost()
    }
}

//MARK: - Custom Methods
extension CategoryVC {
    func setPostTV() {
        postListTV.dataSource = self
        postListTV.delegate = self
        postListTV.backgroundColor = .lightGray1
        postListTV.separatorStyle = .none
        
        bindPostListTVItemSelected()
    }
    
    func bindPostListTVItemSelected() {
        postListTV.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.postListTV.deselectRow(at: indexPath, animated: false)
                
                guard let postDetailVC = ViewControllerFactory.viewController(for: .postDetail) as? PostDetailVC else { return }
                postDetailVC.boardId = self?.postListVM.postAtIndex(indexPath.row).post.boardId
                postDetailVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(postDetailVC, animated: true)
                
            })
            .disposed(by: bag)
    }
    
    func setPost() {
        guard let type = communityType else { return }
        
        PostManager().getPost(type.apiQuery) { posts in
            if let posts = posts {
                self.postListVM = PostListVM(posts: posts)
                
                DispatchQueue.main.async {
                    self.setPostTV()
                }
            } else {
                self.isNoneData = true
                self.setPostTV()
            }
        }
    }
}

extension CategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isNoneData {
            return tableView.frame.height
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isNoneData {
            return 1
        } else {
            return self.postListVM.posts.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNoneData {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.nonePostTVC, for: indexPath)
            cell.isUserInteractionEnabled = false
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.postTVC, for: indexPath) as! PostTVC
            cell.configureCell(with: postListVM.posts[indexPath.row])
            cell.footerView.didTapCommentButton(self)

            return cell
        }
    }
}

