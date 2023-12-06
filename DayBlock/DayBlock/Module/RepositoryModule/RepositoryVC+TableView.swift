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
    
    /// 날짜가 변경됨에 따라 테이블 뷰를 업데이트 합니다.
    func updateTableView(date: Date) {
        
        // 날짜 업데이트
        let repositoryItems = groupDataManager.fetchAllData(for: date)
        repositortyManager.updateCurrentItems(repositoryItems)
        viewManager.summaryView.tableView.reloadData()
        updateTableViewHeight()
        
        // 만약 해당하는 날짜에 블럭이 없다면 라벨 출력
        var alpha: CGFloat = 0
        alpha = repositoryItems.isEmpty ? 1 : 0
        viewManager.summaryView.noTrackingLabel.alpha = alpha
    }
    
    /// 테이블 뷰의 높이를 구하는 메서드입니다.
    private func calculateTableViewHeight() -> CGFloat {
        let tableView = viewManager.summaryView.tableView
        let cellCount = CGFloat(repositortyManager.currentItems().count)
        
        // 만약 0개라면 적당히 3.5개 정도의 셀을 가지고 있는 높이 값으로 반환
        if cellCount == 0 {
            return tableView.rowHeight * 3.5
        }
        
        let height = tableView.rowHeight * cellCount + 24 // 마진값
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
        
        // UI 설정
        let currentItem = repositortyManager.currentItems()[indexPath.row]
        cell.iconBlock.symbol.image = UIImage(systemName: currentItem.blockIcon)
        cell.iconBlock.backgroundColor = UIColor(rgb: currentItem.groupColor)
        cell.taskLabel.text = currentItem.blockTaskLabel
        cell.timeLabel.text = repositortyManager.trackingTimeString(to: indexPath.row)
        cell.plus.textColor = UIColor(rgb: currentItem.groupColor)
        cell.outputLabel.text = repositortyManager.totalOutput(to: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RepositoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 선택 비활성화
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
