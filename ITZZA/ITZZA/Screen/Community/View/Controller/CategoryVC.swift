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
    let dummyData = PostModel(userId:0,
                              boardId: 0,
                              categoryName: "",
                              profileImgURL: "",
                              nickName: "익명의 사용자",
                              postTitle: "ㅁㄴㅇㄹ",
                              postContent: "ㅁㄴㅇㄹ",
                              createdAt: "1시간 전",
                              imageCnt: 1,
                              commentCnt: 1,
                              likeCnt: 4)
    let dummyData2 = PostModel(userId:0,
                               boardId: 0,
                               categoryName: "",
                               profileImgURL: "",
                               nickName: "익명의 사용자",
                               postTitle: "ㅁㄴㅇㄹ",
                               postContent: "ㅁㄴㅇㄹ",
                               createdAt: "1시간 전",
                               imageCnt: 1,
                               commentCnt: 1,
                               likeCnt: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindTV()
        setPostTV()
    }
}

//MARK: - Custom Methods
extension CategoryVC {
    func setPostTV() {
        postListTV.delegate = self
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

extension CategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
