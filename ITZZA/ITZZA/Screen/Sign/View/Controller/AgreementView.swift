//
//  AgreementView.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/09.
//

import UIKit

class AgreementView: UIView {
    
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var contextTextView: UITextView!
    
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
        contextTextView.layer.cornerRadius = 5
        contextTextView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 12)
        contextTextView.font = UIFont.SFProDisplayRegular(size: 13)
        contextTextView.text = readTextFile()
    }
    
    private func setContentView() {
        insertXibView(with: Identifiers.agreementView)
    }
    
    private func readTextFile() -> String {
        var result = ""
        let path = Bundle.main.path(forResource: "Agreement.txt", ofType: nil)
        guard path != nil else { return "" }
        
        do {
            result = try String(contentsOfFile: path!, encoding: .utf8)
        }
        catch {
            result = ""
        }
        return result
    }

}
