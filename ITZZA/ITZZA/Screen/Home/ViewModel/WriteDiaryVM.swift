//
//  WriteDiaryVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/24.
//

import RxSwift
import RxCocoa
import Photos

class WriteDiaryVM {
    
    var disposeBag = DisposeBag()
    let minimumLineSpacing: CGFloat = 20
    
}

// MARK: - Related to Adding Images
extension WriteDiaryVM {
    func addImageToCollectionView(_ images: [UIImage],
                                  _ imageListView: ImageCollectionView) {
        imageListView.selectedImages = images
        imageListView.imageCV.reloadData()
    }
    
    func convertAssetToImages(_ selectedAssets: [PHAsset],
                              _ imageListView: ImageCollectionView) {
        imageListView.selectedImages = selectedAssets.map {
            let imageManager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            var image = UIImage()
            
            imageManager.requestImage(for: $0,
                                         targetSize: CGSize(width:300, height: 300),
                                         contentMode: .aspectFit,
                                         options: option) { (result, info) in
                image = result!
            }
            
            let data = image.jpegData(compressionQuality: 0.7)
            let newImage = UIImage(data: data!)!
            
            return newImage
        }
    }
}
