//
//  ViewController+.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/01.
//

import UIKit

extension UIViewController {
    func showSignInErrorAlert(_ message: String?) {
        let alertController = UIAlertController(title: "로그인 에러",
                                                message: message,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인",
                                   style: .default)

        alertController.addAction(action)

        present(alertController, animated: true)
    }
    
    func showSignUpErrorAlert(_ message: String?) {
        let alertController = UIAlertController(title: "회원가입 에러",
                                                message: message,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인",
                                   style: .default)

        alertController.addAction(action)

        present(alertController, animated: true)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
