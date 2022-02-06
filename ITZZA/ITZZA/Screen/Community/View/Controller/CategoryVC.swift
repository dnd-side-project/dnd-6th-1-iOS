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
    let dummyData = PostModel(nickName: "익명의 사용자",
                              profileImgURL: "",
                              likeCnt: 4,
                              commentCnt: 1,
                              bookmarkCnt: 2,
                              createdAt: "1시간 전",
                              boardId: 0,
                              categoryName: "",
                              postTitle: "ㅁㄴㅇㄹ",
                              postContent: "ㅁㄴㅇㄹ",
                              imageCnt: 1)
    let dummyData2 = PostModel(nickName: "익명의 사용자",
                              profileImgURL: "",
                              likeCnt: 14,
                              commentCnt: 14,
                              bookmarkCnt: 14,
                              createdAt: "3시간 전",
                              boardId: 0,
                              categoryName: "",
                              postTitle: "ㅁㄴㅇㄹ",
                              postContent: "ㅁㄴㅇㄹ",
                              imageCnt: 0)
    
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
        postListTV.separatorStyle = .none
        
        bindPostListTVItemSelected()
    }
    
    func bindPostListTVItemSelected() {
        postListTV.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.postListTV.deselectRow(at: indexPath, animated: false)
                
                guard let postDetailVC = ViewControllerFactory.viewController(for: .postDetail) as? PostDetailVC else { return }
                postDetailVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(postDetailVC, animated: true)
                
            })
            .disposed(by: bag)
    }
    
    func bindTV() {

        let dataSource = RxTableViewSectionedReloadDataSource<PostDataSource>(
          configureCell: { dataSource, tableView, indexPath, item in
              let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.postTVC, for: indexPath) as! PostTVC
              cell.configureCell(with: item)
              cell.bindButtonAction()
              return cell
        })
        
        let sections = [
            PostDataSource(section: 0, items: [dummyData, dummyData2])
        ]

        Observable.just(sections)
          .bind(to: postListTV.rx.items(dataSource: dataSource))
          .disposed(by: bag)
    }
}
