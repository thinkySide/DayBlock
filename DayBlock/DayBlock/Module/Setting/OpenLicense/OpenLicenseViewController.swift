//
//  OpenLicenseViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/19/23.
//

import UIKit

final class OpenLicenseViewController: UIViewController {
    
    private let viewManager = OpenLicenseView()
    private let openLicenseData = OpenLicenseDataStore()
    
    // MARK: - ViewController Life Cycle
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
    }
    
    // MARK: - Setup Method
    private func setupNavigation() {
        title = "오픈소스"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
    }
    
    private func setupTableView() {
        let tableView = viewManager.tableView
        tableView.register(OpenLicenseTableViewCell.self, forCellReuseIdentifier: OpenLicenseTableViewCell.cellID)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableView
extension OpenLicenseViewController: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openLicenseData.list().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OpenLicenseTableViewCell.cellID) as? OpenLicenseTableViewCell else { return UITableViewCell() }
        let data = openLicenseData.list()[indexPath.row]
        cell.mainLabel.text = data.name
        cell.urlLabel.text = data.url
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 셀 클릭 시, 바로 비활성화되는 애니메이션 추가
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 인터넷 창 열기
        guard let url = openLicenseData.fetchURL(to: indexPath.row) else {
            print("URL 로드에 실패했습니다.")
            return
        }
        
        UIApplication.shared.open(url)
    }
}
