//
//  EmotionAnalyzeView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/12.
//

import UIKit

class EmotionAnalyzeView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var diaryListCV: UICollectionView!
    @IBOutlet weak var diaryListCVHeight: NSLayoutConstraint!
    
    var diaryCount: Int?
    let cellHeight = 64
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.emotionAnalyzeView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureDiaryListCV() {
        diaryListCV.dataSource = self
        diaryListCV.delegate = self
        
        diaryListCV.register(UINib(nibName: Identifiers.emotionAnalyzeCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.emotionAnalyzeCVC)
    
        diaryListCV.backgroundColor = .clear
        
        setDiaryListCVHeight()
    }
    
    func setDiaryListCVHeight() {
        diaryListCVHeight.constant = CGFloat((cellHeight + 10) * (diaryCount ?? 0))
    }
}

// MARK: - UICollectionViewDataSource
extension EmotionAnalyzeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        diaryCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifiers.emotionAnalyzeCVC,
            for: indexPath) as? EmotionAnalyzeCVC
        else { return UICollectionViewCell() }
        
        //        cell.configureCell(with: selectedImages[indexPath.row], and: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EmotionAnalyzeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width,
                      height: CGFloat(cellHeight))
    }
}
