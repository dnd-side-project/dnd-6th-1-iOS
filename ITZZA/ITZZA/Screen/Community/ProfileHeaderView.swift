//
//  ProfileHeaderView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit

class ProfileHeaderView: UIView {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var createAt: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
    }
    
    private func setContentView() {
        guard let view = loadViewFromNib(with: Identifiers.profileHeaderView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
    }
}
