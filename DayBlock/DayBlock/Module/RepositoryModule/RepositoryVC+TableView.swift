//
//  RepositoryVC+TableView.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import UIKit

extension RepositoryViewController {
    
    /// 테이블 뷰 기본 설정 메서드입니다.
    func setupTableView() {
        let tableView = viewManager.summaryView.tableView
        tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: SummaryTableViewCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        updateTableViewHeight()
    }
    
    /// 테이블 뷰의 높이를 구하는 메서드입니다.
    private func calculateTableViewHeight() -> CGFloat {
        let tableView = viewManager.summaryView.tableView
        let cellCount = CGFloat(repositortyManager.currentItems().count)
        let height = tableView.rowHeight * cellCount + 24 // 마진값
        print(height)
        return height
    }
    
    /// 테이블 뷰의 높이를 업데이트 하는 메서드입니다.
    func updateTableViewHeight() {
        let summaryView = viewManager.summaryView
        summaryView.heightConstraint.constant = calculateTableViewHeight()
    }
}

// MARK: - UITableViewDataSource
extension RepositoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositortyManager.currentItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.id, for: indexPath) as? SummaryTableViewCell else { return UITableViewCell() }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RepositoryViewController: UITableViewDelegate {
    //
}
