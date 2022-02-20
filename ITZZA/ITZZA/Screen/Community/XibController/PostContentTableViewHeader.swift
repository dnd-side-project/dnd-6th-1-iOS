//
//  PostContentTableViewHeader.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/08.
//

import UIKit
import SnapKit

class PostContentTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var headerView: ProfileHeaderView!
    @IBOutlet weak var footerView: PostButtonsView!
    @IBOutlet weak var postContentView: PostContentView!
    @IBOutlet weak var postButtonViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.postContentTableViewHeader) else { return }
        self.addSubview(view)

        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(imageScrollView)
    }
    
    func setPostButtonViewTopSpace() {
        if imageScrollView.image.count == 0 {
            postButtonViewTopSpace.constant = 0
        } else {
            postButtonViewTopSpace.constant = 40
        }
    }
}
