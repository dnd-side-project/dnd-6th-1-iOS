//
//  EmotionCV.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/20.
//

import UIKit

enum GrayEmoji: String, CaseIterable {
    case angry = "GrayEmoji_Angry"
    case comfy = "GrayEmoji_Comfy"
    case confuse = "GrayEmoji_Confuse"
    case sad = "GrayEmoji_Sad"
    case lonely = "GrayEmoji_Lonely"
}

class EmotionView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let minimumLineSpacing = CGFloat(19)
    let emojiArray = GrayEmoji.allCases.map {
        UIImage(named: $0.rawValue)
    }
    let emojiLabelArray = ["화남", "편안함", "혼란", "서글픔", "외로움"]
    var emojiStatusArray = Array(repeating: false, count: 5)
    var selectedEmojiNumber: Int?
    
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
    
        cell.emojiBackground.layer.cornerRadius = cell.frame.width / 2
        
        cell.update(GrayEmoji.allCases[indexPath.row].rawValue,
                    emojiStatusArray[indexPath.row],
                    emojiLabelArray[indexPath.row])
        
        return cell
    }
    
}

extension EmotionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let num = selectedEmojiNumber else {
            emojiStatusArray[indexPath.item].toggle()
            selectedEmojiNumber = indexPath.item
            collectionView.reloadData()
            return false
        }
        
        emojiStatusArray[num].toggle()
        emojiStatusArray[indexPath.item].toggle()
        selectedEmojiNumber = indexPath.item
        collectionView.reloadData()
        
        return true
    }
}

extension EmotionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.frame.width - minimumLineSpacing * 4) / 5
        let cellHeight = cellWidth * 1.52
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
