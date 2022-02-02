//
//  WritePostVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift

class AddPostVC: UIViewController {

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
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
}
