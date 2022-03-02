//
//  SearchPostVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftKeychainWrapper

class SearchPostVC: UIViewController {
    @IBOutlet weak var naviBackButton: UIButton!
    @IBOutlet weak var naviSearchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var removeAllButton: UIButton!
    @IBOutlet weak var searchHistoryTV: UITableView!
    @IBOutlet weak var divisionLine: UIView!
    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var keywordContentView: KeywordContentView!
    
    var keywords = [SearchKeywordModel]()
    let bag = DisposeBag()
    let apiSession = APISession()
    var isNoneData = false
    private let menu = ["내용", "사용자"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyword()
        configureNavigationBar()
        configureSearchBar()
        setNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Configure
extension SearchPostVC {
    func configureNavigationBar() {
        configureButtonColor()
        didTapBackButton()
        didTapSearchButton()
    }
    
    func configureSearchBar() {
        searchBar.placeholder = "검색"
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .primary
        
        searchBar.searchTextField.textColor = .darkGray6
        searchBar.searchTextField.backgroundColor = .clear
        
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        
        if let clearButton = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            
            clearButton.tintColor = .primary
        }
    }
    
    func configureTabView(){
        //TODO: - FIX
        tabView.menu = menu
        tabView.tabCV.reloadData()
        
        keywordContentView.menu = menu
        keywordContentView.keywordContentCV.reloadData()
    }
    
    func configureButtonColor() {
        searchBar.searchTextField.rx.text
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                if text == "" {
                    self.naviBackButton.tintColor = .darkGray6
                    self.naviSearchButton.tintColor = .darkGray6
                    self.divisionLine.backgroundColor = .lightGray3
                } else {
                    self.naviBackButton.tintColor = .primary
                    self.naviSearchButton.tintColor = .primary
                    self.divisionLine.backgroundColor = .primary
                }
            })
            .disposed(by: bag)
    }
    
    func configureSearchHistoryTV() {
        if keywords.count == 0 {
            isNoneData = true
        }
        searchHistoryTV.dataSource = self
        searchHistoryTV.delegate = self
        searchHistoryTV.separatorStyle = .none
        searchHistoryTV.isScrollEnabled = false
        
        didTapRemoveAllButton()
    }
    
    // MARK: - Network
    func setKeyword() {
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        getKeyword(userId) { [weak self] keyword in
            guard let self = self else { return }
            if let keyword = keyword {
                self.keywords = keyword
                DispatchQueue.main.async {
                    self.configureSearchHistoryTV()
                }
            }
        }
    }
    
    func getKeyword(_ userId: String, _ completion: @escaping ([SearchKeywordModel]?) -> ()) {
        let baseURL = "http://13.125.239.189:3000/users/"
        guard let url = URL(string: baseURL + userId + "/histories") else { return }
        guard let token: String = KeychainWrapper.standard[.myToken] else { return }
        let header: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200...399)
            .responseDecodable(of: [SearchKeywordModel].self) { response in
                switch response.result {
                case .success(let decodedPost):
                    completion(decodedPost)
                case .failure:
                    completion(nil)
                }
            }
    }
    
    func deletePost(_ userId: String, _ historyId: String?) {
        let baseURL = "http://13.125.239.189:3000/users/"
        guard let url = URL(string: baseURL + (userId) + "/histories/" + (historyId ?? "")) else { return }
        guard let token: String = KeychainWrapper.standard[.myToken] else { return }
        let header: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .delete, headers: header).responseData { response in
            switch response.result {
            case .success:
                break
            case .failure:
                break
            }
        }
    }
    
    // MARK: - tap event
    func didTapBackButton() {
        naviBackButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.isNavigationBarHidden = false
            })
            .disposed(by: bag)
    }
    
    func didTapSearchButton() {
        naviSearchButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                if self.naviSearchButton.tintColor == .primary {
                    let urlString = "http://13.125.239.189:3000/boards?keyword=" + self.searchBar.text!
                    let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    let url = URL(string: encodedStr)!
                    self.apiSession.getRequest(with: urlResource<SearchedResultModel>(url: url))
                        .withUnretained(self)
                        .subscribe(onNext: { owner, result in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(let response):
                                self.keywordContentView.post = response
                                self.configureTabView()
                                self.tabView.tabCV.selectItem(at: [0,0], animated: false, scrollPosition: .left)
                            }
                        })
                        .disposed(by: self.bag)
                    
                    self.view.sendSubviewToBack(self.searchHistoryTV)
                }
            })
            .disposed(by: bag)
    }
    
    func didTapRemoveAllButton() {
        removeAllButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                guard let userId: String = KeychainWrapper.standard[.userId] else { return }
                self.deletePost(userId, nil)
                self.isNoneData = true
                self.searchHistoryTV.reloadData()
            })
            .disposed(by: bag)
    }
    
    // MARK: - Notification
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(pushUserPostListView), name:.whenUserPostListTapped, object: nil)
    }
    
    @objc func pushUserPostListView(_ notification: Notification) {
        guard let userPostListVC = ViewControllerFactory.viewController(for: .userPostList) as? UserPostListVC else { return }
        guard let object = notification.object as? [String?], let userId = object[0], let userName = object[1] else { return }
        userPostListVC.userId = Int(userId)
        userPostListVC.userName = userName
        navigationController?.pushViewController(userPostListVC, animated: true)
    }
    
    @objc private func deleteCell(sender: UIButton) {
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let cell = searchHistoryTV.cellForRow(at: indexPath) as! HistoryTVC
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        deletePost(userId, "\(cell.historyId!)")
        keywords.remove(at: indexPath.row)
        self.searchHistoryTV.deleteRows(at: [indexPath], with: .none)
        if self.keywords.count == 0 {
            self.isNoneData = true
        }
        self.searchHistoryTV.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchPostVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isNoneData {
            return 1
        } else {
            return keywords.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNoneData {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.historyNoneTVC, for: indexPath)
            cell.isUserInteractionEnabled = false
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.historyTVC, for: indexPath) as? HistoryTVC else { return UITableViewCell() }
            cell.configureCell(keywords[indexPath.row])
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
}
// MARK: - UITableViewDelegate
extension SearchPostVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
