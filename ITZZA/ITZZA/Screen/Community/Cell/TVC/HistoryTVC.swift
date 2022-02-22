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
        
    }
}

extension HistoryTVC {
    func configureCell(_ keyword: String) {
        self.keyword.text = keyword
    }
}
