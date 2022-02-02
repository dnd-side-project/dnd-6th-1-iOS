//
//  CommunityVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/25.
//

import UIKit
import Tabman
import Pageboy
import RxSwift

class CommunityVC: TabmanViewController {
    private var viewControllers: Array<UIViewController> = []
    
    @IBOutlet weak var categoryTB: UIView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
}

//MARK: - Custom Methods
extension CommunityVC {
    func configureView() {
        configureCategoryView()
    }
    
    func configureNavigationBar() {
        navigationController?.setNaviBarTitle(navigationItem: self.navigationItem, title: "커뮤니티")
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
        
        setNaviBarItems()
    }
    
    func configureCategoryView() {
        setCategoryIndicator()
        setCategoryPage()
    }
}

//MARK: - setting Methods
extension CommunityVC {
    func setNaviBarItems() {
        let searchBtn = UIBarButtonItem()
        searchBtn.image = UIImage(systemName: "magnifyingglass")
        
        let addPostBtn = UIBarButtonItem()
        addPostBtn.image = UIImage(systemName: "plus")
        
        navigationItem.rightBarButtonItems = [addPostBtn, searchBtn]
        
        searchBtn.rx.tap
            .bind {
                guard let searchPostVC = UIStoryboard(name: Identifiers.searchPostSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.searchPostVC) as? SearchPostVC else { return }
                
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(searchPostVC, animated: true)
            }
            .disposed(by: bag)
        
        addPostBtn.rx.tap
            .bind {
                guard let addPostVC = UIStoryboard(name: Identifiers.addPostSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.addPostVC) as? AddPostVC else { return }
                
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(addPostVC, animated: true)
            }
            .disposed(by: bag)
    }
    
    func setCategoryPage() {
        let allTab = UIStoryboard.init(name: Identifiers.categorySB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.categoryVC) as! CategoryVC
        let openHeartTab = UIStoryboard.init(name: Identifiers.categorySB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.categoryVC) as! CategoryVC
        let angryTab = UIStoryboard.init(name: Identifiers.categorySB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.categoryVC) as! CategoryVC
        let dealTab = UIStoryboard.init(name: Identifiers.categorySB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.categoryVC) as! CategoryVC
        let questionTab = UIStoryboard.init(name: Identifiers.categorySB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.categoryVC) as! CategoryVC
        
        viewControllers.append(allTab)
        viewControllers.append(openHeartTab)
        viewControllers.append(angryTab)
        viewControllers.append(dealTab)
        viewControllers.append(questionTab)
        
        self.dataSource = self
    }
    
    func setCategoryIndicator() {
        let bar = TMBar.ButtonBar()
        
        bar.backgroundView.style = .flat(color: .white)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0,
                                               left: 20.0,
                                               bottom: 0.0,
                                               right: 20.0)
        bar.buttons.customize { (button) in
            button.tintColor = .systemGray3
            button.selectedTintColor = .black
            
            button.backgroundColor = .white
            button.contentInset = UIEdgeInsets(top: 0.0, left: 17.0, bottom: 0.0, right: 17.0)
            
            button.font = UIFont.SFProDisplayMedium(size: 16)
            button.selectedFont = UIFont.SFProDisplayBold(size: 16)
        }
    
        bar.indicator.weight = .medium
        bar.indicator.tintColor = .black
        bar.indicator.overscrollBehavior = .compress
        
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 14
        bar.layout.transitionStyle = .snap
        
        addBar(bar, dataSource: self, at: .custom(view: categoryTB, layout: nil))
    }
    
}

//MARK: TMBarDataSource
extension CommunityVC: TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "전체")
        case 1:
            return TMBarItem(title: "털어놓자")
        case 2:
            return TMBarItem(title: "화내자")
        case 3:
            return TMBarItem(title: "타협하자")
        case 4:
            return TMBarItem(title: "물어보자")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
}

//MARK: PageboyViewControllerDataSource
extension CommunityVC: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
