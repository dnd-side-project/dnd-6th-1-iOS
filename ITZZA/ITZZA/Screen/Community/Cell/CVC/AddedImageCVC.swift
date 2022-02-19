//
//  AddedImageCVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/18.
//

import UIKit
import SnapKit

class AddedImageCVC: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteImageButton: UIButton!
    
    override func awakeFromNib() {
        configureButton()
    }
}

extension AddedImageCVC {
    func configureButton() {
        deleteImageButton.tintColor = .primary
    }
}
