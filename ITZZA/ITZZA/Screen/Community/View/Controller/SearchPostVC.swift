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
        
        getKeywordHistory()
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
    private func getKeywordHistory() {
        let baseURL = "http://3.36.71.216:3000/users/"
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        guard let url = URL(string: baseURL + userId + "/histories") else { return }
        let resource = urlResource<[SearchKeywordModel]>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let keywords):
                    self.keywords = keywords
                    DispatchQueue.main.async {
                        self.configureSearchHistoryTV()
                    }
                case .failure:
                    self.keywords = []
                }
            })
            .disposed(by: bag)
    }
    
    private func deletePost(_ historyId: String?) {
        let baseURL = "http://3.36.71.216:3000/users/"
        guard let userId: String = KeychainWrapper.standard[.userId] else { return }
        guard let url = URL(string: baseURL + (userId) + "/histories/" + (historyId ?? "")) else { return }
        let resource = urlResource<EmptyModel>(url: url)
        
        apiSession.deleteRequest(with: resource)
            .withUnretained(self)
            .subscribe()
            .disposed(by: bag)
    }
    
    private func getSearchedList() {
        let urlString = "http://3.36.71.216:3000/boards?keyword=" + self.searchBar.text!
        let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodedStr) else { return }
        let resource = urlResource<SearchedResultModel>(url: url)
        
        apiSession.getRequest(with: resource)
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
                    self.getSearchedList()
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
                self.deletePost(nil)
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
        deletePost("\(cell.historyId!)")
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
