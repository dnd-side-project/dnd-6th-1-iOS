//
//  MyRecordVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/25.
//

import UIKit
import RxSwift
import SwiftKeychainWrapper

class MyRecordVC: UIViewController {
    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var keywordContentView: KeywordContentView!
    
    let apiSession = APISession()
    let bag = DisposeBag()
    private let menu = ["내가쓴 글", "댓글", "북마크"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        getMyPost()
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
        keywordContentView.setContentView()
        keywordContentView.setKeywordContentCV()
    }
    
    func getMyPost() {
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        let urlString = "http://13.125.239.189:3000/users/\(userId)/all"
        let url = URL(string: urlString)!
        let resource = urlResource<MyRecordData>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure:
                    owner.configureTabView()
                case .success(let decodedPost):
                    dump(decodedPost)
                    owner.keywordContentView.mypagePost = decodedPost
                    owner.configureTabView()
                }
            })
            .disposed(by: self.bag)
    }
}