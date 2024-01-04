//
//  OnboardingViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    enum Mode {
        case onboarding
        case help
    }
    
    var mode: Mode
    
    private var viewManager: OnboardingView
    
    /// 페이지를 위한 뷰컨트롤러 배열
    var pages: [UIViewController]
    
    var currentIndex: Int {
        let pageViewController = viewManager.pageViewController
        guard let viewController = pageViewController.viewControllers?.first else { return 0 }
        let index = pages.firstIndex(of: viewController) ?? 0
        return index
    }
    
    // MARK: - ViewController LifeCycle
    init(mode: Mode) {
        self.mode = mode
        
        switch mode {
        case .onboarding:
            self.viewManager = OnboardingView(pageNumbers: .four)
            let firstVC = FirstOnboardingViewController(mode: mode)
            let secondVC = SecondOnboardingViewController(mode: mode)
            let thirdVC = ThirdOnboardingViewController(mode: mode)
            let fourthVC = FourthOnboardingViewController(mode: mode)
            pages = [firstVC, secondVC, thirdVC, fourthVC]
            
        case .help:
            self.viewManager = OnboardingView(pageNumbers: .three)
            let firstVC = FirstOnboardingViewController(mode: mode)
            let secondVC = SecondOnboardingViewController(mode: mode)
            let thirdVC = ThirdOnboardingViewController(mode: mode)
            pages = [firstVC, secondVC, thirdVC]
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupPageViewController()
    }
    
    // MARK: - Setup Method
    
    private func setupNavigation() {
        
        // 타이틀 커스텀
        title = "도움말"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
    }
    
    private func setupPageViewController() {
        let pageViewController = viewManager.pageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // 자식 뷰 추가
        addChild(pageViewController)
        
        // ViewController 이벤트와 연결
        pageViewController.didMove(toParent: self)
        
        // 초기 화면 설정
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: true)
    }
    
    @objc func dismissBarButtonItemTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDataSource & UIPageViewControllerDelegate {
    
    /// 왼쪽에서 오른쪽으로 스와이프 하기 직전에 호출, 다음 화면에 어떤 VC가 출력될지 결정
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return pages[previousIndex]
    }
    
    /// 오른쪽에서 왼쪽으로 스와이프 하기 직전에 호출, 다음 화면에 어떤 VC가 출력될지 결정
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == pages.count { return nil }
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            viewManager.pageNumbers.switchPage(to: currentIndex)
        }
    }
}
