//
//  KeywordContentCVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/23.
//

import UIKit

class KeywordContentCVC: UICollectionViewCell {
    @IBOutlet weak var keywordContentTV: UITableView!
    var isUserSearchedList = false
    var isNoneData: Bool?
    var post = SearchedResultModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureTV()
    }
}

extension KeywordContentCVC {
    private func configureTV() {
        keywordContentTV.register(UINib(nibName: Identifiers.keywordContentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.keywordContentTVC)
        keywordContentTV.register(UINib(nibName: Identifiers.searchedUserTVC, bundle: nil), forCellReuseIdentifier: Identifiers.searchedUserTVC)
        keywordContentTV.register(UINib(nibName: Identifiers.noneSearchedContentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.noneSearchedContentTVC)
        
        keywordContentTV.dataSource = self
        keywordContentTV.delegate = self
        keywordContentTV.showsVerticalScrollIndicator = false
        keywordContentTV.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension KeywordContentCVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isUserSearchedList {
            return (post.userResult?.count == 0) ? 1 : post.userResult!.count
        } else {
            return (post.contentResult?.count == 0) ? 1 : post.contentResult!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNoneData ?? true {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.noneSearchedContentTVC, for: indexPath)
            return cell
        }
        
        if isUserSearchedList {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.searchedUserTVC, for: indexPath) as? SearchedUserTVC else { return UITableViewCell() }
            cell.configureCell(post.userResult?[indexPath.row] ?? PostModel())
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.keywordContentTVC, for: indexPath) as? KeywordContentTVC else { return UITableViewCell() }
            cell.configureCell(post.contentResult?[indexPath.row] ?? PostModel())
            return cell
        }
    }
}

extension KeywordContentCVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isUserSearchedList {
            let cell = tableView.cellForRow(at: indexPath) as! SearchedUserTVC
            NotificationCenter.default.post(name: .whenUserPostListTapped, object: ["\(cell.userId!)", cell.userName.text])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isNoneData ?? true {
            return tableView.frame.height
        } else {
            return UITableView.automaticDimension
        }
    }
}
