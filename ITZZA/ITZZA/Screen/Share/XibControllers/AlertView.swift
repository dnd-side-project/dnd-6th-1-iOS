//
//  AlertView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/24.
//

import UIKit
import SnapKit

class AlertView: UIView {
    @IBOutlet weak var alertTitle: UILabel!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.alertView) else { return }
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.primary.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 5
        self.addSubview(view)
        
        view.isHidden = true
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        configureAlertView()
    }
    
    func setAlertTitle(_ title: String) {
        alertTitle.text = title
    }
    
    private func configureAlertView() {
        alertTitle.textColor = .primary
        alertTitle.font = UIFont.SpoqaHanSansNeoRegular(size: 13)
        alertTitle.textAlignment = .center
    }
}
