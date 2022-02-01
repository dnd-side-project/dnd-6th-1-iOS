//
//  CategoryVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/01/31.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CategoryVC: UIViewController {
    @IBOutlet weak var articleListTV: UITableView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

//MARK: - Custom Methods
extension CategoryVC {
    func bindTV() {

    }
}
