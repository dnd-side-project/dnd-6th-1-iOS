//
//  AgreementVM.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/13.
//

import RxSwift
import RxCocoa

class AgreementVM {
    
    var disposeBag = DisposeBag()
    let currentCheckBox = BehaviorRelay(value: false)
    let setCheckBoxOutline = PublishRelay<Bool>()
    let setCheckBoxFill = PublishRelay<Bool>()
    
    init() {
        currentCheckBox
            .withUnretained(self)
            .bind(onNext: { owner, status in
                owner.checkCheckBoxImage(status)
            })
            .disposed(by: disposeBag)
    }
    
    func checkCheckBoxImage(_ status: Bool) {
        if status {
            setCheckBoxFill.accept(true)
        } else {
            setCheckBoxOutline.accept(true)
        }
    }
    
    func getTextFile() -> String {
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
