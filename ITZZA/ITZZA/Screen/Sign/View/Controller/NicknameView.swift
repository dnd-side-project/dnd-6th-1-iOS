//
//  NicknameView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/07.
//

import UIKit

class NicknameView: UIView {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var checkDuplicateButton: UIButton!
    @IBOutlet weak var validNicknameLabel: UILabel!
    
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
        checkDuplicateButton.layer.cornerRadius = 5
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.nicknameView)
    }
    
}
