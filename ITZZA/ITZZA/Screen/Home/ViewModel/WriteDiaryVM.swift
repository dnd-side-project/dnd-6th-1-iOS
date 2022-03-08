//
//  WriteDiaryVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/24.
//

import RxSwift
import RxCocoa
import Photos
import Alamofire

class WriteDiaryVM {
    
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    let postResponseError = PublishSubject<APIError>()
    let postResponseSuccess = PublishSubject<HomeModel>()
    var isPatch = false
    var diaryId: Int?
    var previousImageCount: Int?
    var isInitial = false
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
        if previousImageCount != nil {
            isInitial = false
        } else {
            isInitial = true
            previousImageCount = selectedAssets.count
        }
        
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
        imageListView.imageCV.reloadData()
    }
}

// MARK: - Networking
extension WriteDiaryVM {
    func postDiaryDataToServer(_ date: String,
                               _ emotionView: EmotionView,
                               _ postWriteView: PostWriteView,
                               _ categoryReason: String,
                               _ imageListView: ImageCollectionView) {
        
        var baseURL = ""
        var method: HTTPMethod
        
        if isPatch {
            guard let diaryId = diaryId else {
                return
            }
            baseURL = "https://www.itzza.shop/diaries/\(diaryId)"
            method = .patch
        } else {
            baseURL = "https://www.itzza.shop/diaries"
            method = .post
        }
        
        let url = URL(string: baseURL)!
        let resource = urlResource<HomeModel>(url: url)
        let replacedDate = date.replacingOccurrences(of: ".", with: "-")
        let categoryId = emotionView.selectedEmojiNumber ?? 0
        let actualCategoryId: Int? = categoryId + 1
        let diaryTitle = postWriteView.title.text
        let diaryContent = postWriteView.contents.text
        let diaryModel = HomeModel(date: replacedDate,
                                   categoryId: actualCategoryId,
                                   categoryReason: categoryReason,
                                   diaryTitle: diaryTitle,
                                   diaryContent: diaryContent)
        let diaryParameter = diaryModel.homeModelParam
        
        apiSession.postRequestWithImages(with: resource,
                                         param: diaryParameter,
                                         images: imageListView.selectedImages,
                                         method: method)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.postResponseError.onNext(error)
                    
                case .success(let response):
                    owner.postResponseSuccess.onNext(response)
                }
            })
            .disposed(by: disposeBag)
    }
}
