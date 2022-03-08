//
//  EmptyDiaryView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/16.
//

import UIKit
import SnapKit

class DiaryView: UIView {
    
    @IBOutlet weak var postContentView: PostContentView!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var emotionSentence: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureScrollView()
        setInitialUIValue()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureScrollView()
        setInitialUIValue()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.diaryView)
    }
}

// MARK: - Change UI
extension DiaryView {
    func setInitialUIValue() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
        postContentView.title.text = "제목"
        postContentView.title.textColor = UIColor.lightGray5
        postContentView.contents.text = "오늘은 어떤 하루였나요?"
        postContentView.contents.textColor = UIColor.lightGray5
        lineView.backgroundColor = .lightGray5
        emotionSentence.font = UIFont.SpoqaHanSansNeoBold(size: 15)
        emotionSentence.textColor = UIColor.lightGray5
        emotionSentence.text = "감정 한마디"
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
