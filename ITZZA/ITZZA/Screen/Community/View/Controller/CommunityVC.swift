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
import RxCocoa

class CommunityVC: TabmanViewController {
    @IBOutlet weak var categoryTB: UIView!
    
    let bag = DisposeBag()
    
    private let viewControllers: [CategoryVC] = CommunityType.allCases
        .compactMap { type in
            let vc = ViewControllerFactory.viewController(for: type.viewControllerType) as? CategoryVC
            vc?.communityType = type
            return vc
        }
    
    private var communityTypes: [CommunityType] {
        viewControllers.compactMap(\.communityType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCategoryView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let tabBarView = categoryTB.subviews.compactMap({ $0 as? TMBar }).first,
              let stackView = tabBarView.subviews.compactMap({ $0 as? UIStackView }).first,
              let fadedView = stackView.arrangedSubviews.first,
              let scrollView = fadedView.subviews.compactMap({ $0 as? UIScrollView }).first,
              let layoutGrid = scrollView.subviews.first,
              let verticalStackView = layoutGrid.subviews.compactMap({ $0 as? UIStackView }).first  else {
                  return
              }
        verticalStackView.spacing = 4.0
    }
}

//MARK: - Configure
extension CommunityVC {
    func configureNavigationBar() {
        setNaviBarView()
        setNaviBarItems()
    }
    
    func configureCategoryView() {
        setCategoryIndicator()
        setCategoryPageDataSource()
    }
}

//MARK: - Setup Methods
extension CommunityVC {
    func setNaviBarView() {
        navigationController?.setNaviBarTitle(navigationItem: self.navigationItem, title: "커뮤니티")
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
    }
    
    func setNaviBarItems() {
        let searchBtn = UIBarButtonItem()
        searchBtn.image = UIImage(systemName: "magnifyingglass")
        
        let addPostBtn = UIBarButtonItem()
        addPostBtn.image = UIImage(systemName: "plus")
        
        navigationItem.rightBarButtonItems = [addPostBtn, searchBtn]
        
        searchBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let searchPostVC = ViewControllerFactory.viewController(for: .searchPost) as? SearchPostVC else { return }
                
                searchPostVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(searchPostVC, animated: true)
            })
            .disposed(by: bag)
        
        addPostBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let addPostVC = ViewControllerFactory.viewController(for: .addPost) as? AddPostVC else { return }
                
                addPostVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(addPostVC, animated: true)
            })
            .disposed(by: bag)
    }
    
    func setCategoryPageDataSource() {
        self.dataSource = self
    }
    
    func setCategoryIndicator() {
        let bar = TMBarView<TMHorizontalBarLayout, TabPagerButton, TMLineBarIndicator>()
        
        bar.backgroundView.style = .flat(color: .white)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0,
                                               left: 25.0,
                                               bottom: 0.0,
                                               right: 25.0)
        bar.buttons.customize { (button) in
            button.tintColor = .lightGray6
            button.selectedTintColor = .white
            
            button.layer.cornerRadius = 4
            button.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            
            button.font = UIFont.SpoqaHanSansNeoMedium(size: 15)
            button.selectedFont = UIFont.SpoqaHanSansNeoBold(size: 15)
        }
        
        bar.indicator.cornerStyle = .eliptical
        bar.indicator.weight = .medium
        bar.indicator.tintColor = .primary
        bar.indicator.overscrollBehavior = .compress
        
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 10
        bar.layout.transitionStyle = .snap
        
        addBar(bar, dataSource: self, at: .custom(view: categoryTB, layout: nil))
    }
    
}

//MARK: TMBarDataSource
extension CommunityVC: TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        TMBarItem(title: communityTypes[index].description)
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

class TabPagerButton: Tabman.TMLabelBarButton {
    override func update(for selectionState: TMBarButton.SelectionState) {
        switch selectionState {
        case .selected:
            backgroundColor = .primary
        default:
            backgroundColor = .background
        }
        
        super.update(for: selectionState)
    }
}
