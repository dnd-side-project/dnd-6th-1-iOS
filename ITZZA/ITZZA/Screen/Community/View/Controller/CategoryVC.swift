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
    var isNoneData = true
    let refreshControl = UIRefreshControl()
    
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
        postListTV.showsVerticalScrollIndicator = false
        
        bindRefreshController()
    }
    
    func bindRefreshController() {
        refreshControl.addTarget(self, action: #selector(updateTV(refreshControl:)), for: .valueChanged)
        
        postListTV.refreshControl = refreshControl
    }
    
    @objc func updateTV(refreshControl: UIRefreshControl) {
        self.setPost()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.postListTV.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    func setPost() {
        guard let type = communityType else { return }
        
        PostManager().getPost(type.apiQuery) { posts in
            if let posts = posts {
                self.postListVM = PostListVM(posts: posts)
                self.isNoneData = false
                DispatchQueue.main.async {
                    self.setPostTV()
                }
            } else {
                print(self.isNoneData)
                self.isNoneData = true
                self.setPostTV()
            }
        }
    }
}

extension CategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if postListVM?.posts.count == 0
        || isNoneData {
            return tableView.frame.height
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.postListTV.deselectRow(at: indexPath, animated: false)
        
        guard let postDetailVC = ViewControllerFactory.viewController(for: .postDetail) as? PostDetailVC else { return }
        postDetailVC.boardId = self.postListVM.postAtIndex(indexPath.row).post.boardId
        postDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postDetailVC, animated: true)
    }
}

extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postListVM?.posts.count == 0
            || isNoneData {
            return 1
        } else {
            return self.postListVM.posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if postListVM?.posts.count == 0
            || isNoneData {
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

