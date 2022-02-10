//
//  WritePostVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift

class AddPostVC: UIViewController {
    @IBOutlet weak var chooseCategoryButton: UIButton!
    @IBOutlet weak var addImageBar: ImageAddBar!
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postContents: UITextView!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var imageStackViewHeight: NSLayoutConstraint!
    
    let postContentsPlaceholder = "글쓰기"
    var images: [UIImage] = []
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        setAddImageBar()
        setChooseCategoryButton()
        setPostContentComponent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setImageStackViewHeight()
    }
}

//MARK: - Custom Methods
extension AddPostVC {
    func configureNavigationBar() {
        navigationController?.setSubNaviBarTitle(navigationItem: self.navigationItem, title: "게시글 작성")
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
        navigationController?.setBackButtonOnlyTitle(navigationController: self.navigationController, title: "취소")
        
        let savePost = UIBarButtonItem()
        savePost.title = "저장"
        savePost.rx.tap
            .bind {
                print("Post article")
            }
            .disposed(by: bag)
        
        navigationItem.rightBarButtonItem = savePost
    }
    
    func setAddImageBar() {
        addImageBar.addImageButton.rx.tap
            .bind {
                print("addImage")
            }
            .disposed(by: bag)
    }
    
    func setChooseCategoryButton() {
        chooseCategoryButton.backgroundColor = .systemGray6
        chooseCategoryButton.layer.cornerRadius = chooseCategoryButton.frame.height / 2
        chooseCategoryButton.layer.borderColor = UIColor.systemGray3.cgColor
        chooseCategoryButton.layer.borderWidth = 1
        
        let space = (view.frame.width - 20 - 20) - chooseCategoryButton.frame.height - chooseCategoryButton.intrinsicContentSize.width
        
        var configuration = UIButton.Configuration.plain()
        
        configuration.titlePadding = space
        configuration.imagePadding = space
        
        chooseCategoryButton.configuration = configuration
    }
    
    func setPostContentComponent() {
        postTitle.placeholder = "제목"
        
        postContents.delegate = self
        postContents.setAllMarginToZero()
        postContents.setTextViewPlaceholder(postContentsPlaceholder)
    }
    
    func setImageStackViewHeight() {
        if images.count == 0 {
            imageStackViewHeight.constant = 0
        } else {
            imageStackViewHeight.constant = CGFloat(images.count) * imageStackView.frame.width
        }
    }
}
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
