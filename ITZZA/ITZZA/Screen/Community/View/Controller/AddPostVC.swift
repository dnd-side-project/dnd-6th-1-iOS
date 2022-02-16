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
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postContents: UITextView!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var imageStackViewHeight: NSLayoutConstraint!
    
    var categoryLabel = UILabel()
        .then {
            $0.text = "감정을 선택해주세요"
        }
    
    let postContentsPlaceholder = "글쓰기"
    let categoryTitlePlaceholder = "감정을 선택해주세요"
    let maxImageSelectionCount = 3
    let imageStackViewSpacing: CGFloat = 20
    var images: [UIImage] = []
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureChooseCategoryButton()
        configureImageStackView()
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
        
        chooseCategoryButton.backgroundColor = .systemGray6
        chooseCategoryButton.layer.cornerRadius = chooseCategoryButton.frame.height / 2
        chooseCategoryButton.layer.borderColor = UIColor.systemGray3.cgColor
        chooseCategoryButton.layer.borderWidth = 1

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
    
    func configureImageStackView() {
        setImageStackViewHeight()
        imageStackView.spacing = imageStackViewSpacing
    }
    
    func configurePostContentComponent() {
        postTitle.placeholder = "제목"
        
        postContents.delegate = self
        postContents.setAllMarginToZero()
        postContents.setTextViewPlaceholder(postContentsPlaceholder)
    }
    
    func setImageStackViewHeight() {
        if images.count == 0 {
            imageStackViewHeight.constant = 0
        } else {
            imageStackViewHeight.constant = CGFloat(images.count) * (imageStackView.frame.width + imageStackViewSpacing)
        }
    }
    
    //MARK: - bind
    func bindAddImageBar() {
        let imagePicker = ImagePickerController()
        
        imagePicker.settings.selection.max = self.maxImageSelectionCount
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        imagePicker.settings.theme.selectionStyle = .numbered
        
        addImageBar.addImageButton.rx.tap
            .bind {
                self.presentImagePicker(imagePicker, select: { (asset) in
                }, deselect: { (asset) in
                }, cancel: { (assets) in
                }, finish: { (assets) in
                    self.convertAssetToImages(assets)
                    self.addImageToStackView(self.images)
                    self.setImageStackViewHeight()
                    self.view.layoutIfNeeded()
                }, completion: {
                })
            }
            .disposed(by: bag)
    }
    
    func addImageToStackView(_ images: [UIImage]) {
        images.forEach {
            let imageView = UIImageView(image: $0)
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            imageView.backgroundColor = .black
            self.imageStackView.addArrangedSubview(imageView)
        }
    }
    
    func convertAssetToImages(_ selectedAssets: [PHAsset]) {
        images = selectedAssets.map {
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
    
    func checkInputValid() {
        if postTitle.text!.isEmpty
            || postContents.textColor == .systemGray3
            || categoryLabel.text! == categoryTitlePlaceholder {
            let alert = UIAlertController(title: "필수 입력란을 채워주세요!", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.view.tintColor = .black
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
        if !postTitle.text!.isEmpty
            || postContents.textColor != .systemGray3
            || categoryLabel.text! != categoryTitlePlaceholder {
            let alert = UIAlertController(title: "게시글이 저장되지 않았습니다.\n나가시겠어요?", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.view.tintColor = .black
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
