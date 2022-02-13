//
//  PostButtonsView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift

class PostButtonsView: UIView {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCnt: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    let bag = DisposeBag()
    
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
        guard let view = loadViewFromNib(with: Identifiers.postButtonsView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
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
