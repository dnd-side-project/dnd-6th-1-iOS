//
//  KeywordContentView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/23.
//

import UIKit
import RxSwift

class KeywordContentView: UIView {
    @IBOutlet weak var keywordContentCV: UICollectionView!
    let bag = DisposeBag()
    var menu:[String] = []
    var post = [PostModel]()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
        setKeywordContentCV()
        setNotification()
        bindScrollCV()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        setKeywordContentCV()
        setNotification()
        bindScrollCV()
    }
}

// MARK: - Configure
extension KeywordContentView {
    func setContentView() {
        guard let view = loadXibView(with: Identifiers.keywordContentView) else { return }
        view.backgroundColor = .clear
        
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setKeywordContentCV() {
        keywordContentCV.register(UINib(nibName: Identifiers.keywordContentCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.keywordContentCVC)

        keywordContentCV.dataSource = self
        keywordContentCV.delegate = self
        
        keywordContentCV.isPagingEnabled = true
        keywordContentCV.showsHorizontalScrollIndicator = false
        
        if let layout = keywordContentCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    func bindScrollCV() {
        keywordContentCV.rx.contentOffset
            .withUnretained(self)
            .bind(onNext: { owner, contentOffset in
                if !owner.keywordContentCV.isDragging && !owner.keywordContentCV.isDecelerating { return }
                
                let scrollViewWidth = owner.keywordContentCV.frame.width
                let page = round(contentOffset.x / scrollViewWidth)
                
                if page.isNaN || page.isInfinite { return }
                let indexPath = IndexPath(item: Int(page), section: .zero)
                
                NotificationCenter.default.post(name:.whenKeywordContentViewScrolled, object: indexPath)
            })
            .disposed(by: bag)
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTab), name:.whenTabViewTapped, object: nil)
    }
    
    @objc func scrollToTab(_ notification: Notification) {
        keywordContentCV.scrollToItem(at: notification.object as! IndexPath, at: .left, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension KeywordContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.keywordContentCVC, for: indexPath) as? KeywordContentCVC else { return UICollectionViewCell() }
        cell.post = post
        indexPath.row == 1 ? (cell.isUserSearchedList = true) : (cell.isUserSearchedList = false)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension KeywordContentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: keywordContentCV.frame.width, height: keywordContentCV.frame.height)
    }
}
