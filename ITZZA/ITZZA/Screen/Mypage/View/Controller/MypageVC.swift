//
//  MypageVC.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MypageVC: UIViewController {
    
    @IBOutlet weak var myWritesCV: UICollectionView!
    @IBOutlet weak var checkReportButton: UIButton!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var storyButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    var disposeBag = DisposeBag()
    let mypageVM = MypageVM()
    var profileInfoView = ProfileInfoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        callMypageApi()
        configureNaviBar()
        configureProfileInfoView()
        setInitialUIValue()
        configureCV()
        configureButton()
        bindUI()
        bindVM()
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
        viewSeparator.backgroundColor = .lightGray1
        myWritesCV.layer.cornerRadius = 5
        myWritesCV.backgroundColor = .lightGray1
        checkReportButton.layer.cornerRadius = 5
        checkReportButton.setTitleColor(.white, for: .normal)
        checkReportButton.backgroundColor = .primary
    }
    
    private func configureProfileInfoView() {
        view.addSubview(profileInfoView)
        profileInfoView.settingButton.isHidden = false
        
        profileInfoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(72)
        }
        
        myWritesCV.snp.makeConstraints {
            $0.top.equalTo(profileInfoView.snp.bottom).offset(16)
        }
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
    
    private func callMypageApi() {
        mypageVM.getUserInformation()
    }
    
    private func showReportView() {
        let reportView = ViewControllerFactory.viewController(for: .report)
        navigationController?.pushViewController(reportView, animated: true)
    }
}

extension MypageVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MypageCell", for: indexPath) as! MypageCVC
        
        cell.configure(indexPath.item, mypageVM.myInfo)
        return cell
    }
}

extension MypageVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let myRecordVC = ViewControllerFactory.viewController(for: .myRecord) as? MyRecordVC else { return }

        myRecordVC.hidesBottomBarWhenPushed = true
        myRecordVC.selectedIndex = indexPath
        self.navigationController?.pushViewController(myRecordVC, animated: true)
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

// MARK: - Bindings
extension MypageVC {
    private func bindUI() {
        checkReportButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showReportView()
            })
            .disposed(by: disposeBag)
        
        profileInfoView.settingButton.rx.tap
            .asDriver()
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        mypageVM.getMypageSuccess
            .asDriver(onErrorJustReturn: MypageModel())
            .drive(onNext: { [weak self] response in
                guard let self = self else { return }
                self.profileInfoView.profileImage.image = response.profileImageData
                self.profileInfoView.userEmail.text = response.user?.email
                self.profileInfoView.userNickname.text = response.user?.nickname
                self.myWritesCV.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
