//
//  HistoryTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/22.
//

import UIKit

class HistoryTVC: UITableViewCell {
    @IBOutlet weak var keyword: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setContentView()
    }
}

extension HistoryTVC {
    private func setContentView() {
        selectionStyle = .none
    }

    func configureCell(_ searchKeyword: SearchKeywordModel) {
        self.keyword.text = searchKeyword.keyword
    }
}
