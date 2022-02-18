//
//  HomeVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/25.
//

import UIKit
import SwiftKeychainWrapper

class HomeVC: UIViewController {
    
    var token: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTokenFromKeychain()
    }
    
    private func getTokenFromKeychain() {
        guard let accessToken: String = KeychainWrapper.standard[.myToken] else { return }
        token = accessToken
    }
}
