//
//  HomeVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/25.
//

import UIKit

class HomeVC: UIViewController {
    
    var userEmail: String = ""
    var userPassword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        userEmail = appDelegate.email!
        userPassword = appDelegate.password!
    }



}
