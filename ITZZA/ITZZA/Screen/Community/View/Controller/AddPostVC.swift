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
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        setAddImageBar()
        setChooseCategoryButton()
        setPostContentComponent()
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
    }
    
    func setPostContentComponent() {
        postTitle.placeholder = "제목"
        
        postContents.delegate = self
        postContents.setAllMarginToZero()
        postContents.setTextViewPlaceholder("글쓰기")
    }
}
extension AddPostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.setTextViewPlaceholder("글쓰기")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.setTextViewPlaceholder("글쓰기")
        }
    }
}
