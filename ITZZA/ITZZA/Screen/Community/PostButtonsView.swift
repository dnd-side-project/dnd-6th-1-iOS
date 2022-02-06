//
//  PostButtonsView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift

class PostButtonsView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCnt: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    let bag = DisposeBag()
    
    // awakeFromNib
    override func awakeFromNib() {
        initWithNib()
        
        didTapLikeButton()
        didTapBookmarkButton()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(Identifiers.postButtonsView, owner: self, options: nil)
        addSubview(view)
        setupLayout()
        setUpView()
    }
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
    
    private func setUpView() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
    }
}

//MARK: - Button Event
extension PostButtonsView {
    func didTapLikeButton() {
        likeButton.rx.tap
             .scan(false) { lastState, newState in
                 !lastState
             }
             .subscribe(onNext: {
                 self.likeButton.setImageToggle($0, UIImage(systemName: "heart")!, UIImage(systemName: "heart.fill")!)
                 self.likeCnt.text = self.setButtonCnt($0, self.likeCnt.text!)
             })
             .disposed(by: bag)
    }
    
    func didTapBookmarkButton() {
        bookmarkButton.rx.tap
             .scan(false) { lastState, newState in
                 !lastState
             }
             .subscribe(onNext: {
                 self.bookmarkButton.setImageToggle($0, UIImage(systemName: "bookmark")!, UIImage(systemName: "bookmark.fill")!)
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
}
