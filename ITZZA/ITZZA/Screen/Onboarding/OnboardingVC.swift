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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
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
    
    let images = [
        UIImage(named: "Onboarding_1"),
        UIImage(named: "Onboarding_2"),
        UIImage(named: "Onboarding_3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configure()
        setScrollView()
        setPageController()
        setButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: Custom Method
extension OnboardingVC {
    func setScrollView() {
        scrollView.delegate = self
        
        scrollView.frame = holderView.bounds
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * 3, height: 0)
        scrollView.isPagingEnabled = true
    }
    
    func setPageController() {
        pageController.numberOfPages = 3
        pageController.currentPage = 0
        pageController.pageIndicatorTintColor = .systemGray3
        pageController.currentPageIndicatorTintColor = .primary
    }
    
    func setButtons() {
        nextButton.layer.cornerRadius = 4
        
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .primary
        nextButton.setTitle("다음으로", for: .normal)
        
        nextButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        nextButton.tag = 1
        
        skipButton.tintColor = .darkGray2
        skipButton.titleLabel?.font = UIFont.SpoqaHanSansNeoBold(size: 12)
        skipButton.setUnderline()
    }
    
    func configure() {
        holderView.addSubview(scrollView)
        
        for i in 0..<3 {
            let pageView = UIView(frame: CGRect(x: CGFloat(i) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: pageView.frame.size.width, height: pageView.frame.size.width * 1.16))
            let title = UILabel(frame: CGRect(x: 25, y: 440, width: pageView.frame.size.width - 50, height: 70))
            let explanation = UITextView(frame: CGRect(x: 25, y: 440 + 70, width: pageView.frame.size.width - 50, height: 32))
            
            title.numberOfLines = 0
            title.lineBreakMode = .byCharWrapping
            title.font = UIFont.SpoqaHanSansNeoBold(size: 20)
            pageView.addSubview(title)
            title.text = titles[i]
            
            explanation.setAllMarginToZero()
            explanation.font = UIFont.SpoqaHanSansNeoRegular(size: 12)
            explanation.textColor = .lightGray6
            pageView.addSubview(explanation)
            explanation.text = explanations[i]
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "Onboarding_\(i+1)")
            pageView.addSubview(imageView)
        }
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 3 else {
            //            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            
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
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        if page.isNaN || page.isInfinite { return }
        pageController.currentPage = Int(page)
        nextButton.tag = pageController.currentPage + 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if nextButton.tag == 2 {
            let btnTitle = NSAttributedString(string: "시작하기")
            nextButton.setAttributedTitle(btnTitle, for: .normal)
        } else {
            let btnTitle = NSAttributedString(string: "다음으로")
            nextButton.setAttributedTitle(btnTitle, for: .normal)
        }
    }
}
