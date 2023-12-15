//
//  OnboardingView.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class OnboardingView: UIView {
    
    let pageControlView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let pageNumbers = PageNumbers(pageCount: .four)
    
    /// 페이지 뷰 컨트롤러
    lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageVC
    }()
    
    // MARK: - Initial Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupAutouLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutouLayout() {
        [pageControlView, pageViewController.view].forEach {
            addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        pageControlView.addSubview(pageNumbers)
        pageNumbers.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControlView.topAnchor.constraint(equalTo: topAnchor),
            pageControlView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControlView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControlView.heightAnchor.constraint(equalToConstant: 256),
            
            pageNumbers.bottomAnchor.constraint(equalTo: pageControlView.bottomAnchor, constant: 0),
            pageNumbers.centerXAnchor.constraint(equalTo: pageControlView.centerXAnchor),
            
            pageViewController.view.topAnchor.constraint(equalTo: pageControlView.bottomAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
