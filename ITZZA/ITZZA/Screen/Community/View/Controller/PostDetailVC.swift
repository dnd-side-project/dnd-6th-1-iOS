//
//  PostDetailVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit
import RxSwift
import RxDataSources
import Alamofire
import SwiftKeychainWrapper

class PostDetailVC: UIViewController {
    @IBOutlet weak var commentListTV: UITableView!
    @IBOutlet weak var chatInputView: ChatInputView!
    
    let bag = DisposeBag()
    var post = PostModel()
    var boardId: Int?
    var isScrolled = false
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        setPost()
        setNotification()
    }
}

extension PostDetailVC {
    // MARK: - Configure
    func configureNavigationMenuButton() {
        let menuButton = UIBarButtonItem()
        menuButton.image = UIImage(named: "Menu_Horizontal")
        
        navigationItem.rightBarButtonItem = menuButton
        
        if post.canEdit ?? false {
            menuButton.rx.tap
                .asDriver()
                .drive(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    let menuBottomSheet = MenuBottomSheet()
                    menuBottomSheet.bindButtonAction(.whenEditPostMenuTapped, .whenDeletePostMenuTapped)
                    self.present(menuBottomSheet, animated: true)
                })
                .disposed(by: bag)
        }
    }
    
    func bindRefreshController() {
        refreshControl.addTarget(self, action: #selector(updateTV(refreshControl:)), for: .valueChanged)
        
        commentListTV.refreshControl = refreshControl
    }
    
    @objc func updateTV(refreshControl: UIRefreshControl) {
        self.setPost()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.commentListTV.reloadData()
            refreshControl.endRefreshing()
        }
    }

    func register(){
        commentListTV.register(UINib(nibName: Identifiers.commentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.commentTVC)
        commentListTV.register(PostContentTableViewHeader.self, forHeaderFooterViewReuseIdentifier: Identifiers.postContentTableViewHeader)
    }
    
    func setCommentListTV() {
        commentListTV.dataSource = self
        commentListTV.delegate = self
        commentListTV.backgroundColor = .lightGray1
        commentListTV.separatorStyle = .none
        
        bindRefreshController()
        
        DispatchQueue.main.async {
            self.scrollToComment()
        }
    }
    
    func scrollToComment() {
        if isScrolled {
            commentListTV.scrollToRow(at: [0,0], at: .bottom, animated: true)
        }
    }
    
    
    // MARK: - Notification
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(deletePost), name: .whenDeletePostMenuTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editPost), name: .whenEditPostMenuTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editComment), name: .whenEditCommentMenuTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteComment), name: .whenDeleteCommentMenuTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showToast), name: .popupAlertView, object: nil)
    }
    
    @objc func editPost() {
        guard let editPostVC = ViewControllerFactory.viewController(for: .addPost) as? AddPostVC else { return }
        editPostVC.boardId = self.boardId!
        editPostVC.isEditingView = true
        editPostVC.post = self.post
        self.navigationController?.pushViewController(editPostVC, animated: true)
    }
    
    @objc func editComment() {
        //TODO: - 댓글 수정
        print("댓글 수정")
    }
    
    @objc func deletePost() {
        popupDeleteAlert(alertType: AlertType.shouldPostDelete)
    }
    
    @objc func deleteComment() {
        popupDeleteAlert(alertType: AlertType.shouldCommentDelete)
    }
    
    @objc func showToast() {
        let toastView = AlertView()
        toastView.setAlertTitle(alertType: AlertType.postEdit)
        self.view.addSubview(toastView)
        toastView.snp.makeConstraints {
            $0.bottom.equalTo(chatInputView.snp.top).offset(-20)
            $0.leading.equalToSuperview().offset(52)
            $0.trailing.equalToSuperview().offset(-52)
            $0.height.equalTo(44)
        }
        toastView.showToastView()
    }
    
    // MARK: - Network
    func setPost() {
        PostManager().getPostDetail(boardId ?? 0) { [weak self] posts in
            guard let self = self else { return }
            if let posts = posts {
                self.post = posts
                DispatchQueue.main.async {
                    self.setCommentListTV()
                    self.configureNavigationMenuButton()
                }
            } else {
                self.showEmptyAlert()
            }
        }
    }
    
    func deleteRequest(_ boardId: Int) {
        let baseURL = "https://www.itzza.shop/boards/"
        guard let url = URL(string: baseURL + "\(boardId)") else { return }
        guard let token: String = KeychainWrapper.standard[.myToken] else { return }
        let header: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .delete, headers: header).responseData { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success:
                NotificationCenter.default.post(name: .popupAlertView, object: true)
                self.navigationController?.popViewController(animated: true)
            case .failure:
                self.networkErrorAlert()
            }
        }
    }
    
    
    // MARK: - Alert
    func popupDeleteAlert(alertType: AlertType) {
        let alert = UIAlertController(title: alertType.message, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = .darkGray6
        alert.view.subviews.first?.subviews.first?.subviews.first!.backgroundColor = .white
        let ok = UIAlertAction(title: "네", style: .destructive) { _ in
            switch alertType {
            case .shouldPostDelete:
                self.deleteRequest(self.boardId ?? 0)
            case .shouldCommentDelete:
                print("comment delete")
            default:
                break
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: false, completion: nil)
    }
    
    func networkErrorAlert() {
        let alert = UIAlertController(title: "네트워크 오류", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = .darkGray6
        alert.view.subviews.first?.subviews.first?.subviews.first!.backgroundColor = .white
        let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        self.present(alert, animated: false, completion: nil)
    }
    
    func showEmptyAlert() {
        let alert = UIAlertController(title: "삭제된 게시글입니다", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = .darkGray6
        alert.view.subviews.first?.subviews.first?.subviews.first!.backgroundColor = .white
        let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(ok)
        present(alert, animated: false, completion: nil)
    }
}

// MARK: - UITableViewDelegate
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

// MARK: - UITableViewDataSource
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
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.noneCommentTVC, for: indexPath)
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = .clear
            
            return cell
            
        } else {
            if indexPath == [0,0] {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentCountTVC, for: indexPath) as? CommentCountTVC else { return UITableViewCell() }
                cell.setCommentCount(self.post.commentCnt ?? 0)
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = .clear
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTVC, for: indexPath) as? CommentTVC else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.configureCell(self.post.comments![indexPath.row - 1].comment!)
                cell.didTapMenuButton(self, post.comments![indexPath.row - 1].comment!.canEdit!)
                return cell
            }
        }
    }
}
