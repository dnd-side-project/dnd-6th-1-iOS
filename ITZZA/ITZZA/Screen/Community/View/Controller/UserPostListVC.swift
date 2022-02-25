//
//  UserPostListVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/23.
//

import UIKit
import RxSwift
import Alamofire

class UserPostListVC: UIViewController {
    @IBOutlet weak var postTV: UITableView!
    var userName: String?
    var userId: Int?
    var isNoneData: Bool?
    var post = [PostModel]()
    let apiSession = APISession()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviBarView()
        
        let urlString = "http://13.125.239.189:3000/users/\(userId!)/boards"
        let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedStr)!
        apiSession.getRequest(with: urlResource<[PostModel]>(url: url))
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure:
                    self.isNoneData = true
                    self.configureTV()
                case .success(let decodedPost):
                    self.post = decodedPost
                    self.isNoneData = false
                    DispatchQueue.main.async {
                        self.configureTV()
                    }
                }
            })
            .disposed(by: self.bag)
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
        postTV.register(UINib(nibName: Identifiers.noneSearchedContentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.noneSearchedContentTVC)
        postTV.dataSource = self
        postTV.delegate = self
        postTV.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if isNoneData! {
            postTV.isUserInteractionEnabled = false
            postTV.separatorStyle = .none
        }
    }
}

extension UserPostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (post.count == 0) ? 1 : post.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if post.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.noneSearchedContentTVC, for: indexPath)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.keywordContentTVC, for: indexPath) as? KeywordContentTVC else { return UITableViewCell() }
            cell.configureCell(post[indexPath.row])
            return cell
        }
    }
}

extension UserPostListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if post.count == 0
            || isNoneData! {
            return tableView.frame.height
        } else {
            return UITableView.automaticDimension
        }
    }
}
