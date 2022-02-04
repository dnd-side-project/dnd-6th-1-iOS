//
//  SearchPostVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit

class SearchPostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }
}
// MARK: - Custom Methods
extension SearchPostVC {
    func configureNavigationBar() {
        navigationController?.setSubNaviBarTitle(navigationItem: self.navigationItem, title: "검색")
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
    }
}
