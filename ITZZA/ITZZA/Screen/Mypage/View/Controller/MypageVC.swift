//
//  MypageVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/25.
//

import UIKit

class MypageVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var myWritesCV: UICollectionView!
    @IBOutlet weak var checkReportButton: UIButton!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var storyButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        setInitialUIValue()
        configureCV()
        configureButton()
    }
}

// MARK: - Change UI
extension MypageVC {
    private func configureNaviBar() {
        navigationController?
            .setNaviBarTitle(navigationItem: self.navigationItem,
                             title: "마이페이지")
        
        navigationController?
            .setNaviItemTintColor(navigationController: self.navigationController,
                                  color: .darkGray6)
    }
    
    private func setInitialUIValue() {
        userEmail.font = UIFont.SpoqaHanSansNeoRegular(size: 12)
        userEmail.textColor = .darkGray6
        userNickname.font = UIFont.SpoqaHanSansNeoMedium(size: 17)
        userNickname.textColor = .darkGray6
        viewSeparator.backgroundColor = .lightGray1
        myWritesCV.layer.cornerRadius = 5
        myWritesCV.backgroundColor = .lightGray1
        checkReportButton.layer.cornerRadius = 5
        checkReportButton.setTitleColor(.white, for: .normal)
        checkReportButton.backgroundColor = .primary
    }
    
    private func configureButton() {
        let buttonArray = [storyButton, deleteAccountButton, signOutButton]
        var config = UIButton.Configuration.plain()
        config.imagePadding = 12
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        buttonArray.forEach { btn in
            btn?.configuration = config
            btn?.setTitleColor(.darkGray6, for: .normal)
            btn?.tintColor = .darkGray6
        }
    }
    
    private func configureCV() {
        myWritesCV.delegate = self
        myWritesCV.dataSource = self
        myWritesCV.register(MypageCVC.nib(), forCellWithReuseIdentifier: "MypageCell")
    }
}

extension MypageVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MypageCell", for: indexPath) as! MypageCVC
        
        cell.configure(indexPath.item, "test")
        return cell
    }
}

extension MypageVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
}

extension MypageVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = myWritesCV.frame.width / 3
        let cellHeight = myWritesCV.frame.height
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}
