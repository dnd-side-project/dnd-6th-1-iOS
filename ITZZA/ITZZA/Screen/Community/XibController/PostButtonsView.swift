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
                 self.likeButton.isSelected.toggle()
                 self.likeButton.setImageToggle(self.likeButton.isSelected, UIImage(named: "Heart")!, UIImage(named: "Heart_selected")!)
                 self.likeCnt.text = self.setButtonCnt(self.likeButton.isSelected, self.likeCnt.text!)
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
}
