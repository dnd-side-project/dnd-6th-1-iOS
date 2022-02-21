//
//  ITZZATBC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/25.
//

import UIKit

class ITZZATBC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    //MARK: - Custom Method
    func makeTabVC(vcType: TypeOfViewController, tabBarTitle: String, tabBarImage: String, tabBarSelectedImage: String) -> UIViewController {
        
        let tab = ViewControllerFactory.viewController(for: vcType)
        tab.tabBarItem = UITabBarItem(title: tabBarTitle, image: UIImage(named: tabBarImage), selectedImage: UIImage(named: tabBarSelectedImage))
        tab.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -0.5, bottom: -0.5, right: -0.5)
        return tab
    }
    
    func setTabBar() {
        let homeTab = makeTabVC(vcType: .home, tabBarTitle: "투데이", tabBarImage: "Tab_Home", tabBarSelectedImage: "Tab_Home")
        let communityTab = makeTabVC(vcType: .community, tabBarTitle: "커뮤니티", tabBarImage: "Tab_Community", tabBarSelectedImage: "Tab_Community")
        let mypageTab = makeTabVC(vcType: .mypage, tabBarTitle: "마이", tabBarImage: "Tab_Mypage", tabBarSelectedImage: "Tab_Mypage")
        
        // 탭바 스타일 설정
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        tabBar.tintColor = .primary
        tabBar.unselectedItemTintColor = .lightGray5
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowOpacity = 0.5
        
        // 탭 구성
        let tabs =  [homeTab, communityTab, mypageTab]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
}
