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
    var postListVM: PostListVM!
    var communityType: CommunityType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPost()
        setPostTV()
    }
}

//MARK: - Custom Methods
extension CategoryVC {
    func setPostTV() {
        postListTV.delegate = self
        postListTV.backgroundColor = .lightGray1
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
            PostDataSource(section: 0, items: self.postListVM.posts.reversed())
        ]

        Observable.just(sections)
          .bind(to: postListTV.rx.items(dataSource: dataSource))
          .disposed(by: bag)
    }
    
    func setPost() {
        guard let type = communityType else { return }
        
        PostManager().getPost(type.apiQuery) { posts in
            if let posts = posts {
                self.postListVM = PostListVM(posts: posts)
                
                DispatchQueue.main.async {
                    self.bindTV()
                }
            }
        }
    }
}

extension CategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
