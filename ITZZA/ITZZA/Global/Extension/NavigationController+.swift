//
//  NavigationController+.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import UIKit

extension UINavigationController {
    // navigationBar Title Setting
    func setNaviBarTitle(navigationItem: UINavigationItem?, title: String) {
        let naviTitle = UILabel()
        naviTitle.textColor = .label
        naviTitle.text = title
        naviTitle.font = UIFont.SFProDisplayBold(size: 22)
        
        navigationItem!.leftBarButtonItem = UIBarButtonItem.init(customView: naviTitle)
    }
    
    func setSubNaviBarTitle(navigationItem: UINavigationItem?, title: String) {
        navigationItem!.title = title
    }
    
    func setBackButtonOnlyTitle(navigationController: UINavigationController?, title: String) {
        let image = UIImage()
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        navigationController?.navigationBar.topItem?.title = title
    }
    
    func setNaviItemTintColor(navigationController: UINavigationController?, color: UIColor) {
        navigationController?.navigationBar.tintColor = color
    }
}
