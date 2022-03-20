//
//  NavigationController+.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import UIKit

extension UINavigationController {
    // navigationBar Title Setting
    func setNaviBarTitle(navigationItem: UINavigationItem, title: String, font: UIFont) {
        let naviTitle = UILabel()
        naviTitle.textColor = .label
        naviTitle.text = title
        naviTitle.font = font
        navigationItem.title = ""
        
        let paddingView = UIView()
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: paddingView), UIBarButtonItem.init(customView: naviTitle)]
    }
    
    func setSubNaviBarTitle(navigationItem: UINavigationItem, title: String) {
        navigationItem.title = title
    }
    
    func setSub(navigationItem: UINavigationItem,
                navigationBar: UINavigationBar?,
                title: String) {
        navigationItem.title = title
        navigationBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont.SpoqaHanSansNeoBold(size: 20)]
    }
    
    func setBackButtonWithTitle(navigationItem: UINavigationItem, title: String) {
        let naviTitle = UILabel()
        naviTitle.textColor = .darkGray6
        naviTitle.text = title
        naviTitle.font = .SpoqaHanSansNeoBold(size: 22)

        navigationItem.leftBarButtonItems = [
            UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"),
                                 style: .done,
                                 target: self,
                                 action: #selector(popViewController(animated:))),
            UIBarButtonItem.init(customView: naviTitle)
        ]
    }
    
    func setBackButtonOnlyTitle(navigationController: UINavigationController?, title: String) {
        navigationController?.navigationBar.topItem?.title = title
    }
    
    func setNaviItemTintColor(navigationController: UINavigationController?, color: UIColor) {
        navigationController?.navigationBar.tintColor = color
    }
}
