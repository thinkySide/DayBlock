//
//  RepositoryVC+TableView.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import UIKit

extension RepositoryViewController {
    
    func setupTableView() {
        let tableView = viewManager.summaryView.tableView
        tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: SummaryTableViewCell.id)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension RepositoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.id, for: indexPath) as? SummaryTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .red
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RepositoryViewController: UITableViewDelegate {
    //
}
