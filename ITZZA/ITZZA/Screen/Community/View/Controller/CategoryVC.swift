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
    
    let apiSession = APISession()
    let bag = DisposeBag()
    var postListVM: PostListVM!
    var communityType: CommunityType?
    var isNoneData = true
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotification()
        getPostList()
    }
}

extension CategoryVC {
    // MARK: - Configure
    func bindRefreshController() {
        refreshControl.addTarget(self, action: #selector(updateTV(refreshControl:)), for: .valueChanged)
        
        postListTV.refreshControl = refreshControl
    }
    
    @objc func updateTV(refreshControl: UIRefreshControl) {
        self.getPostList()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.postListTV.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    func setPostTV() {
        postListTV.dataSource = self
        postListTV.delegate = self
        postListTV.backgroundColor = .lightGray1
        postListTV.separatorStyle = .none
        postListTV.showsVerticalScrollIndicator = false
        
        bindRefreshController()
    }
    
    // MARK: - Notification
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showToast), name: .popupAlertView, object: nil)
    }
    
    @objc func showToast(_ notification: Notification) {
        let toastView = AlertView()
        switch notification.object as! ToastType {
        case .postDeleted:
            toastView.setAlertTitle(alertType: .postDeleted)
        case .postPost:
            toastView.setAlertTitle(alertType: .postPost)
        default:
            break
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
    
    // MARK: - Network
    private func getPostList() {
        let baseURL = "https://www.itzza.shop/boards"
        guard let type = communityType else { return }
        guard let url = URL(string: baseURL + type.apiQuery) else { return }
        let resource = urlResource<[PostModel]>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let postList):
                    self.postListVM = PostListVM(posts: postList)
                    self.isNoneData = false
                    DispatchQueue.main.async {
                        self.setPostTV()
                    }
                case .failure:
                    self.isNoneData = true
                    self.setPostTV()
                }
                
            })
            .disposed(by: bag)
    }
}

// MARK: - UITableViewDelegate
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

// MARK: - UITableViewDataSource
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

