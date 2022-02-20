//
//  PostButtonsView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift
import Alamofire
import SwiftKeychainWrapper

class PostButtonsView: UIView {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCnt: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    let bag = DisposeBag()
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
    }
}

//MARK: - Button Event
extension PostButtonsView {
    func didTapLikeButton() {
        likeButton.rx.tap
             .subscribe(onNext: {
                 self.postLikeStatus(self.boardId ?? 0)
             })
             .disposed(by: bag)
    }
    
    func didTapBookmarkButton() {
        bookmarkButton.rx.tap
             .subscribe(onNext: {
                 self.bookmarkButton.isSelected.toggle()
                 self.bookmarkButton.setImageToggle(self.bookmarkButton.isSelected, UIImage(named: "Bookmark")!, UIImage(named: "Bookmark_selected")!)
             })
             .disposed(by: bag)
    }
    
    func setButtonCnt(_ state: Bool, _ lastCnt: String) -> String {
        if state {
            return String(Int(lastCnt)! + 1)
        } else {
            return String(Int(lastCnt)! - 1)
        }
    }
    
    func postLikeStatus(_ boardId: Int) {
        let baseURL = "http://13.125.239.189:3000/boards/"
        guard let url = URL(string: baseURL + "\(boardId)" + "/likes") else { return }
        guard let token: String = KeychainWrapper.standard[.myToken] else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        AF.request(request).responseData { response in
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
}
