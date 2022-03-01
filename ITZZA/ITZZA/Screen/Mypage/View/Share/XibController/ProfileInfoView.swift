//
//  ProfileInfoView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/03/01.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileInfoView: UIView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var recentConnect: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureProfileInfoView()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureProfileInfoView()
        bindVM()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.profileInfoView)
    }
}


// MARK: - Change UI
extension ProfileInfoView {
    private func configureProfileInfoView() {
        settingButton.isHidden = true
        recentConnect.isHidden = true
        clockImage.isHidden = true
        userEmail.font = UIFont.SpoqaHanSansNeoRegular(size: 12)
        userEmail.textColor = .darkGray6
        userNickname.font = UIFont.SpoqaHanSansNeoBold(size: 17)
        userNickname.textColor = .darkGray6
    }
}

// MARK: - Bindings
extension ProfileInfoView {
    private func bindUI() {
        
    }
    
    private func bindVM() {
        
    }
}
