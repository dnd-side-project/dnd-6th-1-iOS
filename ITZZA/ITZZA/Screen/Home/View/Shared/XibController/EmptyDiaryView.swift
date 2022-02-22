//
//  EmptyDiaryView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/16.
//

import UIKit
import RxSwift
import RxCocoa

class EmptyDiaryView: UIView {
    
    @IBOutlet weak var contentView: PostWriteView!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    var disposeBag = DisposeBag()
    var dummyArray = [UIImage(named: "Emoji_Sad")!, UIImage(named: "Emoji_Sad")!, UIImage(named: "Emoji_Sad")!]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureContentView()
        configureImageScrollView()
        setInitialUIValue()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureContentView()
        configureImageScrollView()
        setInitialUIValue()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.emptyDiaryView)
    }
}

// MARK: - Change UI
extension EmptyDiaryView {
    func setInitialUIValue() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
    }
    
    func configureContentView() {
        contentView.setTitlePlaceholder("asd")
        contentView.setContentsPlaceholder("sldkjfgbsldfgul")
    }
    
    func configureImageScrollView() {
        imageScrollView.image = dummyArray
        imageScrollView.configurePost()
    }
}

// MARK: - Bindings
extension EmptyDiaryView {
    
}
