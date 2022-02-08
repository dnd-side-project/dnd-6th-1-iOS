//
//  PostDetailVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/06.
//

import UIKit
import RxSwift
import RxDataSources

class PostDetailVC: UIViewController {
    @IBOutlet weak var postContentView: PostContentView!
    @IBOutlet weak var commentListTV: UITableView!
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    @IBOutlet weak var postButtonsView: PostButtonsView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCommentListTV()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit(tableView: commentListTV)
    }
}

//MARK: - Custom Methods
extension PostDetailVC {
    func setCommentListTV() {
        commentListTV.backgroundColor = .systemGray6
        commentListTV.separatorStyle = .none
        commentListTV.register(UINib(nibName: Identifiers.commentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.commentTVC)
        
        bindTV()
        bindPostListTVItemSelected()
    }
    
    func sizeHeaderToFit(tableView: UITableView) {
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            tableView.tableHeaderView = headerView
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
    }
    
    func bindPostListTVItemSelected() {
        commentListTV.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.commentListTV.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
    }
}

extension PostDetailVC {
    func bindTV() {
        let configureCell: (TableViewSectionedDataSource<SectionModel<String, String>>, UITableView,IndexPath, String) -> UITableViewCell = { (datasource, tableView, indexPath,  element) in

            if indexPath == [0,0] {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentCountCell, for: indexPath) as? CommentCountTVC else { return UITableViewCell() }
                cell.setCommentCount(4)
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTVC, for: indexPath) as? CommentTVC else { return UITableViewCell() }
                return cell
            }
        }

        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>.init(configureCell: configureCell)

        datasource.titleForHeaderInSection = { datasource, index in
            return datasource.sectionModels[index].model
        }

        let sections = [
            SectionModel<String, String>(model: "", items: ["","",""])
        ]

        Observable.just(sections)
            .bind(to: commentListTV.rx.items(dataSource: datasource))
            .disposed(by: bag)
    }
}
