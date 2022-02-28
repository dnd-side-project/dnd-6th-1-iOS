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
        
        setNotification()
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
        
        PostManager().getPost(type.apiQuery) { [weak self] posts in
            guard let self = self else { return }
            if let posts = posts {
                self.postListVM = PostListVM(posts: posts)
                self.isNoneData = false
                DispatchQueue.main.async {
                    self.setPostTV()
                }
            } else {
                self.isNoneData = true
                self.setPostTV()
            }
        }
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showToast), name: .popupAlertView, object: nil)
    }
    
    @objc func showToast(_ notification: Notification) {
        let toastView = AlertView()
        if notification.object as! Bool {
            toastView.setAlertTitle("게시글이 삭제 되었습니다")
        } else {
            toastView.setAlertTitle("게시글이 업로드 되었습니다")
        }
        self.view.addSubview(toastView)
        toastView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(52)
            $0.trailing.equalToSuperview().offset(-52)
            $0.height.equalTo(44)
        }
        toastView.showToastView()
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
        postListTV.deselectRow(at: indexPath, animated: false)
        
        guard let postDetailVC = ViewControllerFactory.viewController(for: .postDetail) as? PostDetailVC else { return }
        postDetailVC.boardId = postListVM.postAtIndex(indexPath.row).post.boardId
        postDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}

extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postListVM?.posts.count == 0
            || isNoneData {
            return 1
        } else {
            return postListVM.posts.count
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

