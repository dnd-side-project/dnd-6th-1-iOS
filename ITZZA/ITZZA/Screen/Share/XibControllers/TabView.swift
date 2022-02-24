//
//  tabView.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/23.
//

import UIKit
import SnapKit

class TabView: UIView {
    var tabCV: UICollectionView!
    var tabCollectionViewFlowLayout = UICollectionViewFlowLayout()
          .then {
              $0.scrollDirection = .horizontal
              $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          }
    var menu:[String] = []
    
    // MARK: - Init
   
    override init(frame: CGRect) {
      super.init(frame: frame)
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
    }
    
    override func layoutSubviews() {
        tabCollectionViewFlowLayout.invalidateLayout()
    }
}
// MARK: - Configure
extension TabView {
    func setContentView() {
        guard let view = loadXibView(with: Identifiers.tabView) else { return }
        view.backgroundColor = .clear
        
        configureTabCV()
        view.addSubview(tabCV)
        tabCV.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50.0)
        }
        
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        setNotification()
    }
    
    private func configureTabCV() {
        tabCV = UICollectionView(frame: .zero, collectionViewLayout: tabCollectionViewFlowLayout)
        tabCV.register(TabCVC.self, forCellWithReuseIdentifier: Identifiers.tabCVC)
        
        tabCV.showsHorizontalScrollIndicator = false
        tabCV.isPagingEnabled = true
        
        tabCV.delegate = self
        tabCV.dataSource = self
        
        tabCV.selectItem(at: IndexPath(item: .zero, section: .zero),
                                      animated: false,
                                      scrollPosition: [])
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTab), name:.whenKeywordContentViewScrolled, object: nil)
    }
    
    @objc func scrollToTab(_ notification: Notification) {
        tabCV.selectItem(at: notification.object as? IndexPath, animated: false, scrollPosition: [])
    }
}

// MARK: - UICollectionViewDataSource
extension TabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.tabCVC, for: indexPath) as? TabCVC else {
            return UICollectionViewCell()
        }
        
        let menu = menu[indexPath.item]
        cell.configureCell(with: menu)
        
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension TabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / CGFloat(menu.count), height: collectionView.frame.height)
    }
}
// MARK: - UICollectionViewDelegate
extension TabView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        collectionView.layoutIfNeeded()
        collectionView.isPagingEnabled = false
        
        UIView.animate(withDuration: 0.2,
                       delay: .zero,
                       options: []) {
            self.tabCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            NotificationCenter.default.post(name:.whenTabViewTapped, object: indexPath)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            self.tabCV.isPagingEnabled = true
        }
    }
}
