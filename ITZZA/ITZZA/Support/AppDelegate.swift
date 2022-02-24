//
//  AppDelegate.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/25.
//

import UIKit
import SwiftKeychainWrapper

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var email: String?
    var password: String?
    var token: String?
    var userId: String?

    static let shared: AppDelegate = AppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let userEmail = UserDefaults.standard.string(forKey: "email"),
              let userPassword: String = KeychainWrapper.standard[.myPassword],
              let userToken: String = KeychainWrapper.standard[.myToken],
              let keychainUserId: String = KeychainWrapper.standard[.userId] else {
                  let signInVC = ViewControllerFactory.viewController(for: .signIn)
                  self.window = UIWindow(frame: UIScreen.main.bounds)
                  self.window?.rootViewController = signInVC
                  self.window?.makeKeyAndVisible()
                  return true
        }
        
        let userInformation = AppDelegate.shared
        userInformation.email = userEmail
        userInformation.password = userPassword
        userInformation.token = userToken
        userInformation.userId = keychainUserId
        
        let tabBarVC = ViewControllerFactory.viewController(for: .tabBar)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarVC
        self.window?.makeKeyAndVisible()
        
        let tabBarAppearance = UITabBarItem.appearance()
        tabBarAppearance.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.SpoqaHanSansNeoRegular(size: 11)], for: .normal)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

