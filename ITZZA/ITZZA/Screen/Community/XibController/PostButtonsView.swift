//
//  PostButtonsView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftKeychainWrapper

class PostButtonsView: UIView {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCnt: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var bag = DisposeBag()
    let apiSession = APISession()
    let onError = PublishSubject<APIError>()
    var boardId: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        didTapLikeButton()
        didTapBookmarkButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        didTapLikeButton()
        didTapBookmarkButton()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.postButtonsView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setButtonColor()
    }
}

extension PostButtonsView {
    // MARK: - Configure
    private func setButtonColor() {
        likeButton.tintColor = .white
        bookmarkButton.tintColor = .white
    }
    
    func setButtonCnt(_ state: Bool, _ lastCnt: String) -> String {
        likeCnt.textColor = .lightGray5
        commentCnt.textColor = .lightGray5
        
        if state {
            return String(Int(lastCnt)! + 1)
        } else {
            return String(Int(lastCnt)! - 1)
        }
    }
    
    //MARK: - Button Event
    func didTapLikeButton() {
        likeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.postLikeStatus(self.boardId ?? 0)
            })
            .disposed(by: bag)
    }
    
    func didTapBookmarkButton() {
        bookmarkButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.postBookmarkStatus(self.boardId ?? 0)
            })
            .disposed(by: bag)

    }
    
    func didTapCommentButton(_ vc: UIViewController) {
        commentButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let postDetailVC = ViewControllerFactory.viewController(for: .postDetail) as? PostDetailVC else { return }
                postDetailVC.boardId = self.boardId
                postDetailVC.isScrolled = true
                postDetailVC.hidesBottomBarWhenPushed = true
                vc.navigationController?.pushViewController(postDetailVC, animated: true)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Network
    func postLikeStatus(_ boardId: Int) {
        let baseURL = "http://3.36.71.216:3000/boards/"
        guard let url = URL(string: baseURL + "\(boardId)" + "/likes") else { return }
        guard let token: String = KeychainWrapper.standard[.myToken] else { return }
        let header: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, headers: header).responseData { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success:
                self.likeButton.isSelected.toggle()
                self.likeButton.setImageToggle(self.likeButton.isSelected, UIImage(named: "Heart")!, UIImage(named: "Heart_selected")!)
                self.likeCnt.text = self.setButtonCnt(self.likeButton.isSelected, self.likeCnt.text!)
            case .failure:
                break
            }
        }
    }
    
    func postBookmarkStatus(_ boardId: Int) {
        let baseURL = "http://3.36.71.216:3000/boards/"
        guard let url = URL(string: baseURL + "\(boardId)" + "/bookmarks") else { return }
        guard let token: String = KeychainWrapper.standard[.myToken] else { return }
        let header: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, headers: header).responseData { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success:
                self.bookmarkButton.isSelected.toggle()
                self.bookmarkButton.setImageToggle(self.bookmarkButton.isSelected, UIImage(named: "Bookmark")!, UIImage(named: "Bookmark_selected")!)
            case .failure:
                break
            }
        }
    }
}
