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
    @IBOutlet weak var postListTV: UITableView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postListTV.dataSource = self
        postListTV.backgroundColor = .systemGray6
    }
}

//MARK: - Custom Methods
extension CategoryVC {
    func bindTV() {

    }
}

extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.postTVC, for: indexPath) as! PostTVC
        
        cell.backgroundColor = .clear
        
        return cell
    }
}
