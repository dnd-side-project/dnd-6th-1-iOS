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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureTV()
    }
}

extension KeywordContentCVC {
    private func configureTV() {
        keywordContentTV.register(UINib(nibName: Identifiers.keywordContentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.keywordContentTVC)
        keywordContentTV.register(UINib(nibName: Identifiers.searchedUserTVC, bundle: nil), forCellReuseIdentifier: Identifiers.searchedUserTVC)
        
        keywordContentTV.dataSource = self
        keywordContentTV.showsVerticalScrollIndicator = false
        keywordContentTV.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension KeywordContentCVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isUserSearchedList {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.searchedUserTVC, for: indexPath) as? SearchedUserTVC else { return UITableViewCell() }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.keywordContentTVC, for: indexPath) as? KeywordContentTVC else { return UITableViewCell() }
            
            return cell
        }
    }
}
