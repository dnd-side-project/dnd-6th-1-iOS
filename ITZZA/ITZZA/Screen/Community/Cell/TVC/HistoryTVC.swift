//
//  HistoryTVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/22.
//

import UIKit
import RxSwift

class HistoryTVC: UITableViewCell {
    @IBOutlet weak var keyword: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
}

//extension HistoryTVC {
//    func didTapDeleteButton() {
//        deleteButton.rx.tap
//            .asDriver()
//            .drive(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                self.dismiss(animated: true)
//            })
//            .disposed(by: bag)
//    }
//}
