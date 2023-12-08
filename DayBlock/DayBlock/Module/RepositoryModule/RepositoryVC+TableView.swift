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
    
    /// 날짜가 변경됨에 따라 달력 뷰(컬렉션뷰) 및 테이블 뷰를 업데이트 합니다.
    func updateRepositoryView(date: Date) {
        
        // 전체 월 기준 날짜 업데이트
        let repositoryItems = groupDataManager.fetchAllMonthDateItem(for: date)
        repositoryManager.updateCurrentItems(repositoryItems)
        
        // 선택된 날짜 기준 업데이트
        let dateString = calendarManager.fullDateFormat(from: date)
        repositoryManager.filterSelectedDate(dateString)
        viewManager.summaryView.tableView.reloadData()
        viewManager.calendarView.calendar.reloadData()
        updateTableViewHeight()
        
        // 만약 해당하는 날짜에 블럭이 없다면 라벨 출력
        var alpha: CGFloat = 0
        alpha = repositoryManager.dayItems.isEmpty ? 1 : 0
        viewManager.summaryView.noTrackingLabel.alpha = alpha
    }
    
    /// 테이블 뷰의 높이를 구하는 메서드입니다.
    private func calculateTableViewHeight() -> CGFloat {
        let tableView = viewManager.summaryView.tableView
        let cellCount = CGFloat(repositoryManager.currentItems().count)
        
        // 만약 0개라면 적당히 3.5개 정도의 셀을 가지고 있는 높이 값으로 반환
        if cellCount == 0 {
            return tableView.rowHeight * 3.5
        }
        
        let height = tableView.rowHeight * cellCount + 24 // 마진값
        return height
    }
    
    /// 테이블 뷰의 높이를 업데이트 하는 메서드입니다.
    private func updateTableViewHeight() {
        let summaryView = viewManager.summaryView
        summaryView.heightConstraint.constant = calculateTableViewHeight()
    }
}

// MARK: - UITableViewDataSource
extension RepositoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryManager.dayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.id, for: indexPath) as? SummaryTableViewCell else { return UITableViewCell() }
        
        // UI 설정
        let currentItem = repositoryManager.dayItems[indexPath.row]
        cell.iconBlock.symbol.image = UIImage(systemName: currentItem.blockIcon)
        cell.iconBlock.backgroundColor = UIColor(rgb: currentItem.groupColor)
        cell.taskLabel.text = currentItem.blockTaskLabel
        cell.timeLabel.text = repositoryManager.trackingTimeString(to: indexPath.row)
        cell.plus.textColor = UIColor(rgb: currentItem.groupColor)
        cell.outputLabel.text = repositoryManager.totalOutput(to: indexPath.row)
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
