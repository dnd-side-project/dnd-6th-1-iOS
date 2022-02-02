//
//  ImageAddBar.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import RxSwift

class ImageAddBar: UIView {
    @IBOutlet weak var addImageButton: UIButton!
    
    let bag = DisposeBag()
    
    override class func awakeFromNib() {
        
    }

}
extension ImageAddBar {
    func setAddImageButton() {
        self.addImageButton.rx.tap
            .bind {
                print("addImage")
            }
            .disposed(by: bag)
    }
}
