//
//  WritePostVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift
import RxCocoa
import BSImagePicker
import Photos
import Then
import SnapKit
import Alamofire
import SwiftKeychainWrapper

class AddPostVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    @IBOutlet weak var addImageBar: ImageAddBar!
    @IBOutlet weak var postWriteView: PostWriteView!
    @IBOutlet weak var imageListView: ImageCollectionView!
    @IBOutlet weak var imageListHeight: NSLayoutConstraint!
    
    var isEditingView = false
    var boardId = 0
    var post: PostModel?
    
    var categoryLabel = UILabel()
        .then {
            $0.text = "감정을 선택해주세요"
            $0.font = UIFont.SpoqaHanSansNeoMedium(size: 15)
            $0.textColor = .darkGray6
        }
    var categoryIndex: Int?
    
    let postTitlePlaceholder = "제목"
    let postContentsPlaceholder = "글쓰기"
    let postContentPlaceholderColor = UIColor.lightGray5
    let categoryTitlePlaceholder = "감정을 선택해주세요"
    let maxImageSelectionCount = 3
    let minimumLineSpacing: CGFloat = 20
    let communityTypes = CommunityType.allCases
    
    let bag = DisposeBag()
    let apiSession = APISession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEditingContentView(post ?? PostModel())
        configureNavigationBar()
        configureChooseCategoryButton()
        configurePostContentComponent()
        setImageCVHeight()
        setNotification()
        bindAddImageBar()
        bindCategoryBottomSheet()
    }
}

//MARK: - Custom Methods
extension AddPostVC {
    func configureEditingContentView(_ post: PostModel) {
        guard let categoryIndex = post.categoryId else { return }
        self.categoryIndex = categoryIndex
        
        let categoryTitle = communityTypes[categoryIndex].description
        categoryLabel.text = categoryTitle
        postWriteView.title.text = post.postTitle
        postWriteView.contents.text = post.postContent
        imageListView.selectedImages = post.postImages ?? []
        setImageCVHeight()
    }
    
    //MARK: - configure
    func configureNavigationBar() {
        navigationController?.setSubNaviBarTitle(navigationItem: self.navigationItem, title: "게시글 작성")
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
        
        let savePostButton = UIBarButtonItem()
        savePostButton.title = "저장"
        savePostButton.tintColor = .primary
        savePostButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.checkInputValid()
            })
            .disposed(by: bag)
        
        let backButton = UIBarButtonItem()
        backButton.image = UIImage(systemName: "chevron.backward")
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.checkWrittenState()
            })
            .disposed(by: bag)
        
        navigationItem.rightBarButtonItem = savePostButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    func configureChooseCategoryButton() {
        scrollView.subviews.first?.addSubview(categoryLabel)
        
        chooseCategoryButton.backgroundColor = .lightGray1
        chooseCategoryButton.tintColor = .darkGray6
        chooseCategoryButton.layer.cornerRadius = chooseCategoryButton.frame.height / 2
        
        let space = chooseCategoryButton.frame.height / 2
        var configuration = UIButton.Configuration.plain()
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                              leading: space,
                                                              bottom: 0,
                                                              trailing: 0)
        chooseCategoryButton.configuration = configuration
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(chooseCategoryButton.snp.leading).offset(space)
            $0.centerY.equalTo(chooseCategoryButton.snp.centerY)
        }
    }
    
    func configurePostContentComponent() {
        postWriteView.contents.delegate = self
        
        postWriteView.setTitlePlaceholder(postTitlePlaceholder)
        postWriteView.setContentsPlaceholder(postContentsPlaceholder)
    }
    
    func setImageCVHeight() {
        if imageListView.selectedImages.count == 0 {
            imageListHeight.constant = 0
        } else {
            imageListHeight.constant = CGFloat(imageListView.selectedImages.count) * (imageListView.imageCV.frame.width + minimumLineSpacing) - minimumLineSpacing
        }
    }
    
    //MARK: - bind
    func bindCategoryBottomSheet() {
        chooseCategoryButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let categoryBottomSheet = CategoryBottomSheetVC()
                categoryBottomSheet.delegate = self
                self.present(categoryBottomSheet, animated: true)
            })
            .disposed(by: bag)
    }
    
    func bindAddImageBar() {
        addImageBar.addImageButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let imagePicker = ImagePickerController(selectedAssets: self.imageListView.selectedAssets)
                
                imagePicker.cancelButton.tintColor = .primary
                imagePicker.doneButton.tintColor = .primary
                imagePicker.settings.theme.selectionFillColor = .primary
                
                imagePicker.settings.selection.max = self.maxImageSelectionCount
                imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
                imagePicker.settings.theme.selectionStyle = .numbered
                
                self.presentImagePicker(imagePicker, select: { (asset) in
                }, deselect: { (asset) in
                }, cancel: { (assets) in
                }, finish: { (assets) in
                    self.convertAssetToImages(assets)
                    self.addImageToCollectionView(self.imageListView.selectedImages)
                    self.setImageCVHeight()
                    self.imageListView.selectedAssets = assets
                }, completion: {
                })
            })
            .disposed(by: bag)
    }
    
    func addImageToCollectionView(_ images: [UIImage]) {
        imageListView.selectedImages = images
        imageListView.imageCV.reloadData()
    }
    
    func convertAssetToImages(_ selectedAssets: [PHAsset]) {
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
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadImageCollectionView), name:.whenDeleteImageButtonTapped, object: nil)
    }
    
    @objc func reloadImageCollectionView(_ notification: Notification) {
        setImageCVHeight()
    }
    
    func checkInputValid() {
        if postWriteView.title.text!.isEmpty
            || postWriteView.contents.textColor == postContentPlaceholderColor
            || categoryLabel.text! == categoryTitlePlaceholder {
            let alert = UIAlertController(title: "필수 입력란을 채워주세요!", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.view.tintColor = .darkGray6
            alert.view.subviews.first?.subviews.first?.subviews.first!.backgroundColor = .white
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(defaultAction)
            present(alert, animated: false, completion: nil)
        } else {
            if isEditingView {
                postPost(boardId: String(boardId), method: .patch)
            } else {
                postPost(boardId: "", method: .post)
            }
        }
    }
    
    func checkWrittenState(){
        if !postWriteView.title.text!.isEmpty
            || postWriteView.contents.textColor != postContentPlaceholderColor
            || categoryLabel.text! != categoryTitlePlaceholder
            || !imageListView.selectedImages.isEmpty {
            let alert = UIAlertController(title: "게시글이 저장되지 않았습니다.\n나가시겠어요?", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.view.tintColor = .darkGray6
            alert.view.subviews.first?.subviews.first?.subviews.first!.backgroundColor = .white
            let ok = UIAlertAction(title: "네", style: .destructive) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: false, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func postPost(boardId: String, method: HTTPMethod) {
        let postURL = "http://13.125.239.189:3000/boards/\(boardId)"
        let url = URL(string: postURL)!
        let postInformation = PostModel(categoryId: categoryIndex,
                                        postTitle: postWriteView.title.text,
                                        postContent: postWriteView.contents.text)
        let postParameter = postInformation.postParam
        
        apiSession.postRequestWithImages(with: urlResource<PostModel>(url: url), param: postParameter, images: imageListView.selectedImages, method: method)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .popupAlertView, object: nil)
                    self.navigationController?.popViewController(animated: true)
                case .failure:
                    break
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - UITextViewDelegate
extension AddPostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.setTextViewPlaceholder(postContentsPlaceholder)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.setTextViewPlaceholder(postContentsPlaceholder)
        }
    }
}

// MARK: - Protocol
extension AddPostVC: CategoryTitleDelegate {
    func getCategoryTitle(_ title: String, _ index: Int) {
        self.categoryLabel.text = title
        self.categoryIndex = index
    }
}
