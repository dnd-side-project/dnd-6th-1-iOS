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
    
    let apiSession = APISession()
    let bag = DisposeBag()
    var post = PostModel()
    var boardId: Int?
    var isScrolled = false
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        configureLayout()
        getPost()
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
    
    func configureLayout() {
        hideKeyboard()
        
        chatInputView.snp.makeConstraints {
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
        }
    }
    
    func bindRefreshController() {
        refreshControl.addTarget(self, action: #selector(updateTV(refreshControl:)), for: .valueChanged)
        
        commentListTV.refreshControl = refreshControl
    }
    
    @objc func updateTV(refreshControl: UIRefreshControl) {
        self.getPost()
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
        NotificationCenter.default.addObserver(self, selector: #selector(postEditCompleted), name: .popupAlertView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postComment), name: .whenPostComment, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(patchComment), name: .whenEditComment, object: nil)
    }
    
    @objc func editPost() {
        guard let editPostVC = ViewControllerFactory.viewController(for: .addPost) as? AddPostVC else { return }
        editPostVC.boardId = self.boardId!
        editPostVC.isEditingView = true
        editPostVC.post = self.post
        self.navigationController?.pushViewController(editPostVC, animated: true)
    }
    
    @objc func postComment() {
        postCommentRequest(boardId: self.boardId!)
    }
    
    @objc func editComment(_ notification: Notification) {
        guard let object = notification.object as? [Int?],
              let commentId = object[0],
              let commentIndex = object[1] else { return }
        chatInputView.isEdit = true
        chatInputView.editingCommentId = commentId
        chatInputView.textInputField.becomeFirstResponder()
        chatInputView.textInputField.text = post.comments![commentIndex - 1].comment?.commentContent
        commentListTV.scrollToRow(at: [0,commentIndex], at: .bottom, animated: true)
    }
    
    @objc func patchComment() {
        guard let commentId = chatInputView.editingCommentId else { return }
        patchCommentRequest(boardId: self.boardId!, commentId: commentId)
        chatInputView.isEdit = false
    }
    
    @objc func deletePost() {
        popupDeleteAlert(alertType: AlertType.shouldPostDelete,
                         commentId: nil,
                         commentIndex: nil)
    }
    
    @objc func deleteComment(_ notification: Notification) {
        guard let object = notification.object as? [Int?],
              let commentId = object[0],
              let commentIndex = object[1] else { return }
        popupDeleteAlert(alertType: AlertType.shouldCommentDelete,
                         commentId: commentId,
                         commentIndex: commentIndex)
    }
    
    @objc func postEditCompleted(_ notification: Notification) {
        switch notification.object as! AlertType {
        case .commentDeleted:
            showToast(alertType: .commentDeleted)
        default:
            //TODO: - post, patch 나누면 case 분류
            showToast(alertType: AlertType.postEdit)
        }
    }
    
    // MARK: - Network
    private func getPost() {
        let baseURL = "https://www.itzza.shop/boards"
        guard let boardId = boardId else { return }
        guard let url = URL(string: baseURL + "/\(boardId)") else { return }
        let resource = urlResource<PostModel>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let post):
                    self.post = post
                    DispatchQueue.main.async {
                        self.setCommentListTV()
                        self.configureNavigationMenuButton()
                    }
                case .failure:
                    self.showEmptyAlert()
                }
            })
            .disposed(by: bag)
    }
    
    private func deletePostRequest(_ boardId: Int) {
        let baseURL = "https://www.itzza.shop/boards"
        guard let url = URL(string: baseURL + "/\(boardId)") else { return }
        let resource = urlResource<EmptyModel>(url: url)
        
        apiSession.deleteRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .popupAlertView, object: AlertType.postDeleted)
                    self.navigationController?.popViewController(animated: true)
                case .failure:
                    self.networkErrorAlert()
                }
            })
            .disposed(by: bag)
    }
    
    private func deleteCommentRequest(_ boardId: Int, _ commentId: Int, _ commentIndex: IndexPath) {
        let baseURL = "https://www.itzza.shop/boards"
        guard let url = URL(string: baseURL + "/\(boardId)/comments/\(commentId)") else { return }
        let resource = urlResource<EmptyModel>(url: url)
        
        apiSession.deleteRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .popupAlertView, object: AlertType.commentDeleted)
                    self.post.comments?.remove(at: commentIndex.row - 1)
                    self.commentListTV.deleteRows(at: [commentIndex], with: .none)
                    DispatchQueue.main.async {
                        self.commentListTV.reloadData()
                    }
                case .failure:
                    self.networkErrorAlert()
                }
            })
            .disposed(by: bag)
    }
    
    private func postCommentRequest(boardId: Int) {
        let postURL = "http://13.125.239.189:3000/boards/\(boardId)/comments"
        let url = URL(string: postURL)!
        let postInformation = CommentModel(commentContent: chatInputView.textInputField.text)
        let postParameter = postInformation.param
        let resource = urlResource<CommentModel>(url: url)
        
        apiSession.postRequest(with: resource, param: postParameter)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    self.showToast(alertType: AlertType.commentPost)
                case .failure:
                    self.networkErrorAlert()
                }
            })
            .disposed(by: bag)
    }
    
    private func patchCommentRequest(boardId: Int, commentId: Int) {
        let postURL = "http://13.125.239.189:3000/boards/\(boardId)/comments/\(commentId)"
        let url = URL(string: postURL)!
        let postInformation = CommentModel(commentContent: chatInputView.textInputField.text)
        let postParameter = postInformation.param
        let resource = urlResource<CommentModel>(url: url)
        
        apiSession.patchRequest(with: resource, param: postParameter)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    self.showToast(alertType: AlertType.commentEdit)
                case .failure:
                    self.networkErrorAlert()
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - Alert
    func popupDeleteAlert(alertType: AlertType, commentId: Int?, commentIndex: Int?) {
        let alert = UIAlertController(title: alertType.message, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = .darkGray6
        alert.view.subviews.first?.subviews.first?.subviews.first!.backgroundColor = .white
        let ok = UIAlertAction(title: "네", style: .destructive) { _ in
            switch alertType {
            case .shouldPostDelete:
                self.deletePostRequest(self.boardId ?? 0)
            case .shouldCommentDelete:
                self.deleteCommentRequest(self.boardId ?? 0, commentId!, [0, commentIndex!])
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
    
    func showToast(alertType: AlertType) {
        let toastView = AlertView()
        toastView.setAlertTitle(alertType: alertType)
        self.view.addSubview(toastView)
        toastView.snp.makeConstraints {
            $0.bottom.equalTo(chatInputView.snp.top).offset(-20)
            $0.leading.equalToSuperview().offset(52)
            $0.trailing.equalToSuperview().offset(-52)
            $0.height.equalTo(44)
        }
        toastView.showToastView()
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
                cell.setCommentCount(self.post.comments?.count ?? 0)
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = .clear
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTVC, for: indexPath) as? CommentTVC else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.configureCell(self.post.comments?[indexPath.row - 1].comment! ?? CommentModel(), indexPath.row)
                cell.didTapMenuButton(self, post.comments?[indexPath.row - 1].comment!.canEdit ?? false)
                return cell
            }
        }
    }
}
