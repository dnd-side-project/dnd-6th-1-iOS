//
//  PostContentTableViewHeader.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/08.
//

import UIKit

class PostContentTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var headerView: ProfileHeaderView!
    @IBOutlet weak var footerView: PostButtonsView!
    @IBOutlet weak var postContentView: PostContentView!
    @IBOutlet weak var postButtonViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    var image:[UIImage] = []
    
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

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        view.addSubview(scrollView)
    }
    
    func configurePost() {
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViews = image.map { image -> UIImageView in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            imageView.backgroundColor = .black
            return imageView
        }
        
        let stackView = UIStackView(arrangedSubviews: imageViews)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        scrollView.addSubview(stackView)

        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        setPostButtonViewTopSpace()
    }
    
    func setPostButtonViewTopSpace() {
        if image.count == 0 {
            postButtonViewTopSpace.constant = 0
        }
    }
}
