//
//  HomeAlarmVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/18.
//

import UIKit

class HomeAlarmTVC: UITableViewController {
    
    let homeAlarmVM = HomeAlarmVM()
    let cellHeight = CGFloat(89)
    let headerHeight = CGFloat(62)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfiguration()
    }
    
    private func tableViewConfiguration() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.sectionFooterHeight = 0
        tableView.separatorInset = UIEdgeInsets(top: 0,
                                                left: 15,
                                                bottom: 0,
                                                right: 15)
        
        tableView.register(UINib(nibName: Identifiers.homeAlarmCell, bundle: nil),
                           forCellReuseIdentifier: "HomeAlarmCell")
    }
}

// MARK: - Datasource
extension HomeAlarmTVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        headerHeight
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: tableView.frame.width,
                                          height: headerHeight))
        
        let titleLabel = UILabel(frame: CGRect(x: 20,
                                               y: 20,
                                               width: header.frame.width - 40,
                                               height: header.frame.height - 40))
        
        header.backgroundColor = .white
        titleLabel.textColor = .darkGray6
        titleLabel.font = .SpoqaHanSansNeoBold(size: 17)
        titleLabel.text = homeAlarmVM.sectionArray[section]
        
        header.addSubview(titleLabel)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: Identifiers.homeAlarmCell,
                    for: indexPath) as? HomeAlarmCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        var cellImage = UIImage()
        var cellColor = UIColor()
        
        if indexPath.section == 0 {
            cellImage = homeAlarmVM.decideImage(homeAlarmVM.dummyToday[indexPath.row].type!)
            cellColor = homeAlarmVM.decideColor(homeAlarmVM.dummyToday[indexPath.row].read!)
        } else if indexPath.section == 1 {
            cellImage = homeAlarmVM.decideImage(homeAlarmVM.dummyThisWeek[indexPath.row].type!)
            cellColor = homeAlarmVM.decideColor(homeAlarmVM.dummyThisWeek[indexPath.row].read!)
        } else {
            cellImage = homeAlarmVM.decideImage(homeAlarmVM.dummyLastMonth[indexPath.row].type!)
            cellColor = homeAlarmVM.decideColor(homeAlarmVM.dummyLastMonth[indexPath.row].read!)
        }
        
        cell.alarmTypeImageView.image = cellImage
        cell.alarmTypeImageView.tintColor = cellColor
        cell.alarmTypeLabel.textColor = cellColor

        return cell
    }
}

// MARK: - Delegate
extension HomeAlarmTVC {
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
}
