//
//  ImageCollectionView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/20.
//

import UIKit
import Photos
import SnapKit
import RxSwift
import RxCocoa

class ImageCollectionView: UIView {
    @IBOutlet weak var imageCV: UICollectionView!
    
    let numberOfImages = PublishRelay<Int>()
    
    var selectedImages: [UIImage] = []
    var selectedAssets: [PHAsset] = []
    let minimumLineSpacing: CGFloat = 20
    var viewWidth: CGFloat?
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
        configureImageCV()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureImageCV()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.imageCollectionView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        viewWidth = view.frame.width
    }
    
    private func configureImageCV() {
        imageCV.dataSource = self
        imageCV.delegate = self
        imageCV.isScrollEnabled = false
        
        imageCV.register(UINib(nibName: Identifiers.addedImageCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.addedImageCVC)
    }
    
    @objc private func deleteCell(sender: UIButton) {
        imageCV.deleteItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        selectedImages.remove(at: sender.tag)
        selectedAssets.remove(at: sender.tag)
        
        
        NotificationCenter.default.post(name:.whenDeleteImageButtonTapped, object: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension ImageCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.addedImageCVC, for: indexPath) as! AddedImageCVC

        cell.configureCell(with: selectedImages[indexPath.row], and: indexPath)

        cell.deleteImageButton.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
        
        numberOfImages.accept(selectedImages.count)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImageCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: viewWidth ?? 0, height: viewWidth ?? 0)
    }
}
