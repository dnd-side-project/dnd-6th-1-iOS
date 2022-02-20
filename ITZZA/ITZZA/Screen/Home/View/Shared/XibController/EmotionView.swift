//
//  EmotionCV.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/20.
//

import UIKit

enum Emoji: String, CaseIterable {
    case angry = "Emoji_Angry"
    case comfy = "Emoji_Comfy"
    case confuse = "Emoji_Confuse"
    case sad = "Emoji_Sad"
    case lonely = "Emoji_Lonely"
}

class EmotionView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let minimumLineSpacing = CGFloat(19)
    let emojiArray = Emoji.allCases.map {
        UIImage(named: $0.rawValue)
    }
    let emojiLabelArray = ["화남", "편안함", "혼란", "서글픔", "외로움"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        emotionViewConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        emotionViewConfigure()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.emotionView)
    }
    
    private func emotionViewConfigure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmotionCVC.nib(), forCellWithReuseIdentifier: "EmotionCell")
    }
}

// MARK: - Configurations
extension EmotionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCell", for: indexPath) as! EmotionCVC
        
        cell.emojiBackground.backgroundColor = .orange
        cell.emojiBackground.layer.cornerRadius = cell.frame.width / 2
        cell.configure(with: emojiArray[indexPath.row]!, emojiLabelArray[indexPath.row])
        
        return cell
    }
    
}

extension EmotionView: UICollectionViewDelegate {
    
}

extension EmotionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.frame.width - minimumLineSpacing * 4) / 5
        
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    
}
