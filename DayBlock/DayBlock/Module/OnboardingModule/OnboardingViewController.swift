//
//  OnboardingViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    /// 페이지 뷰 컨트롤러
    lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageVC
    }()
    
    /// 페이지를 위한 뷰컨트롤러 배열
    lazy var pages: [UIViewController] = {
        let firstVC = FirstOnboardingViewController()
        let secondVC = SecondOnboardingViewController()
        return [firstVC, secondVC]
    }()
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
    }
    
    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // AutoLayout
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // ViewController 이벤트와 연결
        pageViewController.didMove(toParent: self)
        
        // 초기 화면 설정
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: true)
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
}
