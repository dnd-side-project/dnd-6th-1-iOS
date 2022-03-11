//
//  HomeAlarmCell.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/03/09.
//

import UIKit

class HomeAlarmCell: UITableViewCell {
    
    @IBOutlet weak var alarmTypeImageView: UIImageView!
    @IBOutlet weak var alarmTypeLabel: UILabel!
    @IBOutlet weak var alarmTopicLabel: UILabel!
    @IBOutlet weak var alarmDescriptionLabel: UILabel!
    @IBOutlet weak var alarmDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAlarmCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let width = subviews[0].frame.width

        for view in subviews where view != contentView {
            if view.frame.width == width {
                view.removeFromSuperview()
            }
        }
    }
    
    func configureAlarmCell() {
        alarmTypeLabel.font = .SpoqaHanSansNeoBold(size: 10)
        alarmTopicLabel.font = .SpoqaHanSansNeoMedium(size: 13)
        alarmDescriptionLabel.font = .SpoqaHanSansNeoRegular(size: 12)
        alarmDateLabel.font = .SpoqaHanSansNeoRegular(size: 10)
        alarmTypeLabel.textColor = .lightGray6
        alarmTopicLabel.textColor = .darkGray6
        alarmDescriptionLabel.textColor = .lightGray6
        alarmDateLabel.textColor = .lightGray6
    }
    
}
