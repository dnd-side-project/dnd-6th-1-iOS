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
    @IBOutlet weak var commentListTV: UITableView!
    
    let bag = DisposeBag()
    var post = PostModel()
    var boardId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPost()
    }
}

//MARK: - Custom Methods
extension PostDetailVC {
    func setPost() {
        PostManager().getPostDetail(boardId ?? 0) { posts in
            if let posts = posts {
                self.post = posts
                DispatchQueue.main.async {
                    self.setCommentListTV()
                }
            }
        }
    }
    
    func setCommentListTV() {
        commentListTV.delegate = self
        commentListTV.backgroundColor = .lightGray1
        commentListTV.separatorStyle = .none
        
        register()
        bindTV()
        bindPostListTVItemSelected()
    }
    
    func register(){
        commentListTV.register(UINib(nibName: Identifiers.commentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.commentTVC)
        commentListTV.register(PostContentTableViewHeader.self, forHeaderFooterViewReuseIdentifier: Identifiers.postContentTableViewHeader)
    }
    
    func bindPostListTVItemSelected() {
        commentListTV.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if indexPath.row != 0 {
                    print(indexPath.row, "댓글 눌림")
                }
            })
            .disposed(by: bag)
    }
}

extension PostDetailVC {
    func bindTV() {
        let configureCell: (TableViewSectionedDataSource<SectionModel<String, String>>, UITableView,IndexPath, String) -> UITableViewCell = { (datasource, tableView, indexPath,  element) in

            if indexPath == [0,0] {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentCountCell, for: indexPath) as? CommentCountTVC else { return UITableViewCell() }
                cell.setCommentCount(self.post.commentCnt ?? 0)
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTVC, for: indexPath) as? CommentTVC else { return UITableViewCell() }
                cell.selectionStyle = .none
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

extension PostDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identifiers.postContentTableViewHeader) as? PostContentTableViewHeader else { return nil }
        headerView.configureContents(with: post)
        headerView.imageScrollView.configurePost()
        headerView.setPostButtonViewTopSpace()
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
