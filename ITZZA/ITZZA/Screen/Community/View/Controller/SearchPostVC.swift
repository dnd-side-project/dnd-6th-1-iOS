//
//  SearchPostVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift

class SearchPostVC: UIViewController {
    @IBOutlet weak var naviBackButton: UIButton!
    @IBOutlet weak var naviSearchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureSearchBar()
    }
}
// MARK: - Custom Methods
extension SearchPostVC {
    func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        configureButtonColor()
        didTapBackButton()
    }
    
    func configureSearchBar() {
        searchBar.placeholder = "검색"
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .primary
        
        searchBar.searchTextField.textColor = .darkGray6
        searchBar.searchTextField.backgroundColor = .clear
        
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        
        if let clearButton = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)

            clearButton.tintColor = .primary
        }
    }
    
    func didTapBackButton() {
        naviBackButton.rx.tap
            .subscribe (onNext: {
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.isNavigationBarHidden = false
            })
            .disposed(by: bag)
    }
    
    func configureButtonColor() {
        searchBar.searchTextField.rx.text
            .subscribe(onNext: {
                if $0! == "" {
                    self.naviBackButton.tintColor = .darkGray6
                    self.naviSearchButton.tintColor = .darkGray6
                } else {
                    self.naviBackButton.tintColor = .primary
                    self.naviSearchButton.tintColor = .primary
                }
            })
            .disposed(by: bag)
    }
}
