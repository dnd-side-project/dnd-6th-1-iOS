//
//  CommunityVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/25.
//

import UIKit

class CommunityVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

//MARK: - Custom Methods
extension CommunityVC {
    func configureView() {
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationController?.setNaviBarTitle(navigationItem: self.navigationItem, title: "커뮤니티")
    }
}
