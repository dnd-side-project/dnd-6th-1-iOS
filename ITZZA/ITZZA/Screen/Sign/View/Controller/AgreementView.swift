//
//  AgreementView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/09.
//

import UIKit

class AgreementView: UIView {
    
    @IBOutlet weak var checkBoxView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        setInitialValue()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        setInitialValue()
    }
    
    private func setInitialValue() {
        checkBoxView.layer.cornerRadius = 5
        checkBoxView.layer.borderColor = UIColor.lightGray.cgColor
        checkBoxView.layer.borderWidth = 1
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.agreementView) else { return }
        self.addSubview(view)
    }

}
