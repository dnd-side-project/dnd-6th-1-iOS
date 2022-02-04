//
//  ViewController+.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/01.
//

import UIKit

extension UIViewController {
    func showSignInErrorAlert(_ message: String?) {
        let alertController = UIAlertController(title: "Login Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인",
                                   style: .default)

        alertController.addAction(action)

        present(alertController, animated: true)
    }
}
