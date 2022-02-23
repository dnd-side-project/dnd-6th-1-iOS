//
//  SearchPostVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift

class SearchPostVC: UIViewController {
    @IBOutlet weak var naviBackButton: UIButton!
    @IBOutlet weak var naviSearchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var removeAllButton: UIButton!
    @IBOutlet weak var searchHistoryTV: UITableView!
    @IBOutlet weak var divisionLine: UIView!
    @IBOutlet weak var tabView: TabView!
    
    let bag = DisposeBag()
    var isNoneData = false
    private let menu = ["내용", "사용자"]
    var dummydata = [ "검색어 1", "검색어 2", "검색어 3", "검색어 4", "검색어 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureSearchBar()
        configureSearchHistoryTV()
        configureTabView()
    }
}
// MARK: - Configure
extension SearchPostVC {
    func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
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
        tabView.menu = menu
        tabView.setContentView()
    }
    
    func configureButtonColor() {
        searchBar.searchTextField.rx.text
            .subscribe(onNext: {
                if $0! == "" {
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
        searchHistoryTV.dataSource = self
        searchHistoryTV.delegate = self
        searchHistoryTV.separatorStyle = .none
        searchHistoryTV.isScrollEnabled = false
        
        didTapRemoveAllButton()
    }
    // MARK: - tap event
    func didTapBackButton() {
        naviBackButton.rx.tap
            .subscribe (onNext: {
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.isNavigationBarHidden = false
            })
            .disposed(by: bag)
    }
    
    func didTapSearchButton() {
        naviSearchButton.rx.tap
            .subscribe(onNext: {
                self.view.sendSubviewToBack(self.searchHistoryTV)
                
            })
            .disposed(by: bag)
    }
    
    func didTapRemoveAllButton() {
        removeAllButton.rx.tap
            .subscribe(onNext: {
                self.dummydata.removeAll()
                self.isNoneData = true
                self.searchHistoryTV.reloadData()
            })
            .disposed(by: bag)
    }
    
    @objc private func deleteCell(sender: UIButton) {
        dummydata.remove(at: sender.tag)
        searchHistoryTV.deleteRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
        if self.dummydata.count == 0 {
            self.isNoneData = true
        }
        searchHistoryTV.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchPostVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isNoneData {
            return 1
        } else {
            return dummydata.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNoneData {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.historyNoneTVC, for: indexPath)
            cell.isUserInteractionEnabled = false
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.historyTVC, for: indexPath) as? HistoryTVC else { return UITableViewCell() }
            cell.configureCell(dummydata[indexPath.row])
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
