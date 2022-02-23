//
//  UserPostListVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/23.
//

import UIKit

class UserPostListVC: UIViewController {
    @IBOutlet weak var postTV: UITableView!
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviBarView()
        configureTV()
    }
}

extension UserPostListVC {
    func setNaviBarView() {
        navigationItem.title = (userName ?? "") + "님의 글"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .darkGray6)
    }
    
    func configureTV() {
        postTV.register(UINib(nibName: Identifiers.keywordContentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.keywordContentTVC)
        postTV.dataSource = self
        postTV.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension UserPostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.keywordContentTVC, for: indexPath) as? KeywordContentTVC else { return UITableViewCell() }
        
        return cell
    }
}
