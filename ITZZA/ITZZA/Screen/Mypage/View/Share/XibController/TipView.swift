//
//  TipView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/21.
//

import UIKit
import Lottie

class TipView: UIView {
    @IBOutlet weak var emotionListCV: UICollectionView!
    @IBOutlet weak var writeDiaryButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureEmotionListCV()
        setWriteDiaryButton()
        setLottieAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureEmotionListCV()
        setWriteDiaryButton()
        setLottieAnimation()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.tipView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureEmotionListCV() {
        emotionListCV.dataSource = self
        emotionListCV.delegate = self
        
        emotionListCV.isScrollEnabled = false
        emotionListCV.register(UINib(nibName: Identifiers.emotionListCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.emotionListCVC)
    }
    
    private func setWriteDiaryButton() {
        writeDiaryButton.backgroundColor = .primary
        writeDiaryButton.layer.cornerRadius = 4
        writeDiaryButton.setTitle("일기 작성하기", for: .normal)
        writeDiaryButton.titleLabel?.font = .SpoqaHanSansNeoMedium(size: 12)
        writeDiaryButton.tintColor = .white
    }
    
    private func setLottieAnimation() {
        animationView.clipsToBounds = false
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        animationView.loopMode = .loop
    }
}
// MARK: - UICollectionViewDataSource
extension TipView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifiers.emotionListCVC,
            for: indexPath) as? EmotionListCVC
        else { return UICollectionViewCell() }
        cell.backgroundColor = Emoji.allCases[indexPath.row].color
        cell.layer.cornerRadius = 4
        cell.title.text = Emoji.allCases[indexPath.row].name
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TipView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 40) / 5, height: collectionView.frame.height)
    }
}
