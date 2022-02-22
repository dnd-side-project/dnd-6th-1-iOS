//
//  EmptyDiaryView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/16.
//

import UIKit
import SnapKit

class EmptyDiaryView: UIView {
    
    @IBOutlet weak var postContentView: PostContentView!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lineView: UIView!
    
    var dummyArray = [UIImage(named: "Emoji_Sad")!,
                      UIImage(named: "Emoji_Sad")!,
                      UIImage(named: "Emoji_Sad")!]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureScrollView()
        addImagesToImageScrollView(with: dummyArray)
        setInitialUIValue()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureScrollView()
        addImagesToImageScrollView(with: dummyArray)
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
        postContentView.title.text = "제목"
        postContentView.contents.text = "오늘은 어떤 하루였나요?"
        lineView.backgroundColor = .lightGray5
    }
    
    func configureScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageScrollView.snp.makeConstraints {
            $0.leading.equalTo(scrollView).offset(25)
            $0.trailing.bottom.equalTo(scrollView).offset(-25)
        }
    }
    
    func addImagesToImageScrollView(with images: [UIImage]) {
        imageScrollView.image = images
        imageScrollView.configurePost()
    }
}
