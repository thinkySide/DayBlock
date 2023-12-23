//
//  DeveloperInfoViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/19/23.
//

import UIKit

final class DeveloperInfoViewController: UIViewController {
    
    private let viewManager = DeveloperInfoView()
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupEvent()
    }
    
    // MARK: - Setup Method
    private func setupNavigation() {
        title = "개발자 정보"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
    }
    
    private func setupEvent() {
        addTapGesture(viewManager.githubValue, target: self, action: #selector(githubLinkTapped))
    }
    
    // MARK: - Event Method
    
    @objc func githubLinkTapped() {
        
        // 인터넷 창 열기
        guard let urlString = viewManager.githubValue.text,
              let url = URL(string: urlString) else {
            print("URL 로드에 실패했습니다.")
            return
        }
        
        UIApplication.shared.open(url)
    }
}
