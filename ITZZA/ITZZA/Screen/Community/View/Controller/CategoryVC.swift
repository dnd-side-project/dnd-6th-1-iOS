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
                              likeCnt: 14,
                              commentCnt: 14,
                              bookmarkCnt: 14,
                              createdAt: "3시간 전",
                              boardId: 0,
                              categoryName: "",
                              postTitle: "",
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
    }
    
    // TODO: PostModel, PostDataSource로 구조화
    func bindTV() {

        let dataSource = RxTableViewSectionedReloadDataSource<PostDataSource>(
          configureCell: { dataSource, tableView, indexPath, item in
              let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.postTVC, for: indexPath) as! PostTVC
              cell.configureCell(with: item)
              
              return cell
        })
        
        let sections = [
            PostDataSource(section: 0, items: [dummyData]),
            PostDataSource(section: 0, items: [dummyData])
        ]

        Observable.just(sections)
          .bind(to: postListTV.rx.items(dataSource: dataSource))
          .disposed(by: bag)
    }
}
