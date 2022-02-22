//
//  ProfileHeaderView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/02.
//

import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var category: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureCategoryLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureCategoryLabel()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.profileHeaderView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureCategoryLabel() {
        category.textColor = .primary
        category.layer.borderColor = UIColor.primary.cgColor
        category.layer.borderWidth = 0.5
        category.layer.cornerRadius = 4
    }
}
