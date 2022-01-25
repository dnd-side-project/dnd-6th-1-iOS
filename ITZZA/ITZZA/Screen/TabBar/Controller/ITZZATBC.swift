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
    /// makeTabVC - 탭별 아이템 생성하는 함수
    func makeTabVC(vcType: TypeOfViewController, tabBarTitle: String, tabBarImage: String, tabBarSelectedImage: String) -> UIViewController {
        
        let tab = ViewControllerFactory.viewController(for: vcType)
        tab.tabBarItem = UITabBarItem(title: tabBarTitle, image: UIImage(named: tabBarImage), selectedImage: UIImage(named: tabBarSelectedImage))
        tab.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -0.5, bottom: -0.5, right: -0.5)
        return tab
    }
    
    /// setTabBar - 탭바 Setting
    func setTabBar() {
        
        let homeTab = makeTabVC(vcType: .home, tabBarTitle: "Home", tabBarImage: "", tabBarSelectedImage: "")
        let communityTab = makeTabVC(vcType: .community, tabBarTitle: "Community", tabBarImage: "", tabBarSelectedImage: "")
        let mypageTab = makeTabVC(vcType: .mypage, tabBarTitle: "Mypage", tabBarImage: "", tabBarSelectedImage: "")
        
        // 탭바 스타일 설정
        tabBar.frame.size.height = 65
        tabBar.tintColor = .black
        tabBar.layer.shadowOpacity = 0
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.clipsToBounds = true
        
        // 탭 구성
        let tabs =  [homeTab, communityTab, mypageTab]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
}
