//
//  OnboardingVC.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/02/25.
//

import UIKit
import SnapKit
import Then

class OnboardingVC: UIViewController {
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    let onboardingCnt = 3
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
        configureLayout()
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
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * CGFloat(onboardingCnt), height: 0)
        scrollView.isPagingEnabled = true
    }
    
    func setPageController() {
        pageController.numberOfPages = onboardingCnt
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
    
    func configureLayout() {
        holderView.addSubview(scrollView)
        
        for i in 0..<onboardingCnt {
            let pageView = UIView()
            scrollView.addSubview(pageView)
            pageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(CGFloat(i) * view.frame.width)
                $0.trailing.equalToSuperview().offset(-1 * CGFloat(onboardingCnt - 1 - i) * view.frame.width)
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(view.frame.width)
            }
            
            let imageView = UIImageView()
                .then {
                    $0.contentMode = .scaleAspectFit
                    $0.image = UIImage(named: "Onboarding_\(i+1)")
                }
            pageView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.leading.trailing.top.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.equalTo(pageView.snp.width).multipliedBy(1.16)
            }
            
            let title = UILabel()
                .then {
                    $0.numberOfLines = 0
                    $0.lineBreakMode = .byCharWrapping
                    $0.font = UIFont.SpoqaHanSansNeoBold(size: 20)
                    $0.text = titles[i]
                }
            pageView.addSubview(title)
            title.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(25)
                $0.trailing.equalToSuperview().offset(-25)
                $0.top.equalTo(imageView.snp.bottom).offset(25)
                $0.height.equalTo(55)
            }
            
            let explanation = UITextView()
                .then {
                    $0.setAllMarginToZero()
                    $0.font = UIFont.SpoqaHanSansNeoRegular(size: 12)
                    $0.textColor = .lightGray6
                    $0.text = explanations[i]
                }
            pageView.addSubview(explanation)
            explanation.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(25)
                $0.trailing.equalToSuperview().offset(-25)
                $0.top.equalTo(title.snp.bottom).offset(10)
                $0.height.equalTo(55)
            }
        }
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < onboardingCnt else {
            view.subviews.forEach { view in
                view.removeFromSuperview()
            }
            
            let signInVC = ViewControllerFactory.viewController(for: .signIn)
            signInVC.modalPresentationStyle = .fullScreen
            
            self.view.window?.rootViewController?.dismiss(animated: true) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController?.present(signInVC, animated: true, completion: nil)
            }
            return
        }
        
        if button.tag == onboardingCnt - 1 {
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
        if nextButton.tag == onboardingCnt - 1 {
            let btnTitle = NSAttributedString(string: "시작하기")
            nextButton.setAttributedTitle(btnTitle, for: .normal)
        } else {
            let btnTitle = NSAttributedString(string: "다음으로")
            nextButton.setAttributedTitle(btnTitle, for: .normal)
        }
    }
}
