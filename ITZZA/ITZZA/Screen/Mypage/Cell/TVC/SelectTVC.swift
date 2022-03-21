//
//  SelectTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/15.
//

import UIKit

class SelectTVC: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    var year: Int?
    var week: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .background
        selectedBackgroundView = bgColorView
    }
    
    func configureCell(_ reportPeriodList: ReportPeriodModel) {
        year = reportPeriodList.year ?? 0
        week = reportPeriodList.week ?? 0
        
        title.text = "\(year!)년 \(week!)번째"
        title.font = .SpoqaHanSansNeoRegular(size: 15)
    }
}
