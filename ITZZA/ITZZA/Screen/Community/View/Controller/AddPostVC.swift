//
//  WritePostVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift
import BSImagePicker
import Photos
import Then
import SnapKit

class AddPostVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    @IBOutlet weak var addImageBar: ImageAddBar!
    @IBOutlet weak var postWriteView: PostWriteView!
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var imageCVHeight: NSLayoutConstraint!
    
    var categoryLabel = UILabel()
        .then {
            $0.text = "감정을 선택해주세요"
            $0.font = UIFont.SpoqaHanSansNeoMedium(size: 15)
            $0.textColor = .darkGray6
        }
    
    let postTitlePlaceholder = "제목"
    let postContentsPlaceholder = "글쓰기"
    let postContentPlaceholderColor = UIColor.lightGray5
    let categoryTitlePlaceholder = "감정을 선택해주세요"
    let maxImageSelectionCount = 3
    let minimumLineSpacing: CGFloat = 20
    var selectedImages: [UIImage] = []
    var selectedAssets: [PHAsset] = []
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureChooseCategoryButton()
        configureImageCV()
        bindAddImageBar()
        bindCategoryBottomSheet()
        configurePostContentComponent()
    }
}

//MARK: - Custom Methods
extension AddPostVC {
    //MARK: - configure
    func configureNavigationBar() {
        navigationController?.setSubNaviBarTitle(navigationItem: self.navigationItem, title: "게시글 작성")
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
        
        let savePostButton = UIBarButtonItem()
        savePostButton.title = "저장"
        savePostButton.tintColor = .primary
        savePostButton.rx.tap
            .bind {
                self.checkInputValid()
            }
            .disposed(by: bag)
        
        let backButton = UIBarButtonItem()
               backButton.image = UIImage(systemName: "chevron.backward")
               backButton.rx.tap
                   .bind {
                       self.checkWrittenState()
                   }
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
    
    func configureImageCV() {
        imageCV.dataSource = self
        imageCV.delegate = self
        imageCV.isScrollEnabled = false
        setImageCVHeight()
    }
    
    func configurePostContentComponent() {
        postWriteView.contents.delegate = self
        
        postWriteView.setTitlePlaceholder(postTitlePlaceholder)
        postWriteView.setContentsPlaceholder(postContentsPlaceholder)
    }
    
    func setImageCVHeight() {
        if selectedImages.count == 0 {
            imageCVHeight.constant = 0
        } else {
            imageCVHeight.constant = CGFloat(selectedImages.count) * (imageCV.frame.width + minimumLineSpacing) - minimumLineSpacing
            
            print(imageCV.frame.width)
        }
    }
    
    //MARK: - bind
    func bindAddImageBar() {
        addImageBar.addImageButton.rx.tap
            .bind {
                let imagePicker = ImagePickerController(selectedAssets: self.selectedAssets)
                
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
                    self.addImageToCollectionView(self.selectedImages)
                    self.setImageCVHeight()
                    self.selectedAssets = assets
                }, completion: {
                })
            }
            .disposed(by: bag)
    }
    
    func bindCategoryBottomSheet() {
        chooseCategoryButton.rx.tap
            .asDriver()
            .drive(onNext: {
                let categoryBottomSheet = CategoryBottomSheetVC()
                categoryBottomSheet.delegate = self
                self.present(categoryBottomSheet, animated: true)
            })
            .disposed(by: bag)
    }
    
    func addImageToCollectionView(_ images: [UIImage]) {
        images.forEach {
            let imageView = UIImageView(image: $0)
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        }
        imageCV.reloadData()
    }
    
    func convertAssetToImages(_ selectedAssets: [PHAsset]) {
        selectedImages = selectedAssets.map {
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
            // TODO: - 게시글 post
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func checkWrittenState(){
        if !postWriteView.title.text!.isEmpty
            || postWriteView.contents.textColor != postContentPlaceholderColor
            || categoryLabel.text! != categoryTitlePlaceholder {
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
    
    @objc func deleteCell(sender: UIButton) {
        imageCV.deleteItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        selectedImages.remove(at: sender.tag)
        selectedAssets.remove(at: sender.tag)
        setImageCVHeight()
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
    func getCategoryTitle(_ title: String) {
        self.categoryLabel.text = title
    }
}

// MARK: - UICollectionViewDataSource
extension AddPostVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.addedImageCVC, for: indexPath) as! AddedImageCVC

        cell.backgroundColor = .black
        cell.imageView.image = selectedImages[indexPath.row]
        cell.deleteImageButton.tag = indexPath.row
        cell.deleteImageButton.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
        
        cell.imageView.snp.makeConstraints {
            $0.height.width.equalTo(view.frame.width - 30 * 2)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddPostVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacing
    }
}
