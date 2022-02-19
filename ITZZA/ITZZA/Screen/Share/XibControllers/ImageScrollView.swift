//
//  ImageScrollView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/19.
//

import UIKit
import SnapKit

class ImageScrollView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    var image:[UIImage] = []
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.imageAddBar) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.height.equalTo(stackView.snp.height)
        }
    }
}
