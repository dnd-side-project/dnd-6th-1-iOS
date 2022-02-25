//
//  ReportVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/26.
//

import UIKit
import SnapKit

class ReportVC: UIViewController {
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    var imageView = UIImageView()
    var tmpView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureScrollView()
        configureContentView()
        configureImageView()
    }
    
    private func configureNaviBar() {
        navigationItem.title = "리포트"
        let saveButton = UIBarButtonItem()
        saveButton.title = "저장"
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureContentView() {
        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
    }
    
    private func configureImageView() {
        contentView.addSubview(imageView)
        imageView.image = UIImage(named: "Report_Image")
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalToSuperview().offset(-25)
            $0.height.equalTo(1000)
        }
        
    }
}
