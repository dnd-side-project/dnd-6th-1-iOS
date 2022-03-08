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
        
        defaultState(alertController)
        
        let action = UIAlertAction(title: "확인",
                                   style: .default)

        alertController.addAction(action)

        present(alertController, animated: true)
    }
    
    func showSignUpErrorAlert(_ message: String?) {
        let alertController = UIAlertController(title: "회원가입 에러",
                                                message: message,
                                                preferredStyle: .alert)
        
        defaultState(alertController)
        
        let action = UIAlertAction(title: "확인",
                                   style: .default)

        alertController.addAction(action)

        present(alertController, animated: true)
    }
    
    func showServerErrorAlert(_ message: String?) {
        let alertController = UIAlertController(title: "서버 에러로 인해 요청하신 작업에 실패했습니다",
                                                message: message,
                                                preferredStyle: .alert)
        
        defaultState(alertController)
        
        let action = UIAlertAction(title: "확인",
                                   style: .default)

        alertController.addAction(action)

        present(alertController, animated: true)
    }
    
    private func defaultState(_ alertController: UIAlertController) {
        alertController.view.tintColor = .darkGray6
        alertController.view.backgroundColor = .white
        alertController.view.layer.cornerRadius = 4
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
