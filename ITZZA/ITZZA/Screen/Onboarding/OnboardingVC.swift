//
//  OnboardingVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/25.
//

import UIKit
import SnapKit

class OnboardingVC: UIViewController {
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var button: UIButton!
    
    let scrollView = UIScrollView()
    let titles = [
        "일기를 작성하고\n그날의 감정과 하루를 돌아봐요",
        "작성한 일기들을\n매주 리포트로 확인해요",
        "커뮤니티에서\n다른 사람과 함께 소통해요"
    ]
    
    let explanations = [
        "오늘 느꼈던 감정과 한마디, 일기를 작성하고 \n캘린더에서 바로 확인할 수 있어요",
        "작성한 일기들을 리포트로 모아 일주일 간의\n감정을 한눈에 확인할 수 있어요",
        "이별 감정 5단계의 이름을 따온 카테고리를 활용해서\n비슷한 상황의 사람들과 생각을 나눠봐요"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
        setScrollView()
        setPageController()
        setButton()
    }
}
//MARK: Custom Method
extension OnboardingVC {
    func setScrollView() {
        scrollView.delegate = self
        
        scrollView.frame = holderView.bounds
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * 5, height: 0)
        scrollView.isPagingEnabled = true
    }
    
    func setPageController() {
        pageController.numberOfPages = 3
        pageController.currentPage = 0
        pageController.pageIndicatorTintColor = .systemGray3
        pageController.currentPageIndicatorTintColor = .primary
    }
    
    func setButton() {
        button.layer.cornerRadius = 4
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitle("다음으로", for: .normal)
        
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = 1
    }
    
    func configure() {
        holderView.addSubview(scrollView)
        
        for i in 0..<3 {
            let pageView = UIView()
            scrollView.addSubview(pageView)
            pageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            let imageView = UIImageView()
            let title = UILabel()
            let explanation = UITextView()
            
            title.textAlignment = .left
            title.font = UIFont.SpoqaHanSansNeoBold(size: 20)
            pageView.addSubview(title)
            title.text = titles[i]
            
            explanation.textAlignment = .left
            explanation.font = UIFont.SpoqaHanSansNeoRegular(size: 12)
            pageView.addSubview(explanation)
            explanation.text = explanations[i]
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "Onboarding_\(i+1)")
            pageView.addSubview(imageView)
        }
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 5 else {
            //            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            
//            guard let pvc = self.presentingViewController else { return }
//
//            self.dismiss(animated: true) {
                //                guard let vc = UIStoryboard(name: Identifiers.tabBarSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.teaKKeulTBC) as? TeaKKeulTBC else { return }
                //                vc.modalPresentationStyle = .fullScreen
                //
                //                pvc.present(vc, animated: true, completion: nil)
//            }
            
            return
        }
        
        if button.tag == 2 {
            let btnTitle = NSAttributedString(string: "시작하기")
            button.setAttributedTitle(btnTitle, for: .normal)
        }
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
}
extension OnboardingVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        pageController.currentPage = currentIndex
        button.tag = pageController.currentPage + 1
        print(pageController.currentPage)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if button.tag == 2 {
            let btnTitle = NSAttributedString(string: "시작하기")
            button.setAttributedTitle(btnTitle, for: .normal)
        } else {
            let btnTitle = NSAttributedString(string: "다음으로")
            button.setAttributedTitle(btnTitle, for: .normal)
        }
    }
}
