//
//  MyRecordVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/25.
//

import UIKit
import RxSwift

class MyRecordVC: UIViewController {
    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var keywordContentView: KeywordContentView!
    
    let apiSession = APISession()
    let bag = DisposeBag()
    private let menu = ["내가쓴 글", "댓글", "북마크"]
    let dummyData = [
        PostModel(
                  userId: 1,
                  categoryId: 1,
                  nickname: "asdf",
                  postTitle: "asdfasdf",
                  postContent: "asdfasdfasdfasdf",
                  createdAt: "1분 전",
                  imageCnt: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTabView()
    }
}

extension MyRecordVC {
    func configureNavigationBar() {
        navigationController?.setSubNaviBarTitle(navigationItem: self.navigationItem, title: "게시글 작성")
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
        
        let menuButton = UIBarButtonItem()
        menuButton.image = UIImage(named: "Menu_Horizontal")
        menuButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let menuBottomSheet = MenuBottomSheet()
                self.present(menuBottomSheet, animated: true)
            })
            .disposed(by: bag)
        
        let backButton = UIBarButtonItem()
        backButton.image = UIImage(systemName: "chevron.backward")
        backButton.tintColor = .darkGray6
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
        
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    func configureTabView() {
        tabView.menu = menu
        tabView.setContentView()
        
        keywordContentView.menu = menu
        keywordContentView.mypagePost = dummyData
        keywordContentView.setContentView()
        keywordContentView.setKeywordContentCV()
    }
}
