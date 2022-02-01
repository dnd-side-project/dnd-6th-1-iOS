//
//  CategoryVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CategoryVC: UIViewController {
    @IBOutlet weak var postListTV: UITableView!
    
    let bag = DisposeBag()
    let dummyData = ["사용자닉", "용자닉네", "자닉네임", "갸악"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindTV()
        setPostTV()
    }
}

//MARK: - Custom Methods
extension CategoryVC {
    func setPostTV() {
        postListTV.backgroundColor = .systemGray6
    }
    
    func bindTV() {
        let configureCell: (TableViewSectionedDataSource<SectionModel<String, String>>, UITableView,IndexPath, String) -> UITableViewCell = { (datasource, tableView, indexPath,  element) in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.postTVC, for: indexPath) as? PostTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.headerView.userName.text = element
            return cell
        }

        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>.init(configureCell: configureCell)

        datasource.titleForHeaderInSection = { datasource, index in
            return datasource.sectionModels[index].model
        }

        let sections = [
            SectionModel<String, String>(model: "", items: dummyData)
        ]

        Observable.just(sections)
            .bind(to: postListTV.rx.items(dataSource: datasource))
            .disposed(by: bag)
    }
}
