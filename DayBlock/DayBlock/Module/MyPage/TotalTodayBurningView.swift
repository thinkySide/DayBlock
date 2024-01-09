//
//  TotalTodayBurningView.swift
//  DayBlock
//
//  Created by 김민준 on 12/12/23.
//

import UIKit

final class TotalTodayBurningView: UIView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.bold, size: 19)
        label.textColor = Color.mainText
        label.textAlignment = .center
        label.text = "생산한 블럭을\n차곡차곡 쌓아뒀어요"
        label.numberOfLines = 2
        return label
    }()
    
    let totalInfoIcon: SummaryInfoIcon = {
        let icon = SummaryInfoIcon()
        icon.tagLabel.text = "total"
        icon.valueLabel.unit.text = "개"
        icon.updateColor(UIColor(rgb: 0x4C73FD))
        return icon
    }()
    
    let todayInfoIcon: SummaryInfoIcon = {
        let icon = SummaryInfoIcon()
        icon.tagLabel.text = "today"
        icon.valueLabel.unit.text = "개"
        icon.icon.image = UIImage(systemName: "gauge.with.needle.fill")
        icon.updateColor(UIColor(rgb: 0x2EBB55))
        return icon
    }()
    
    let burningInfoIcon: SummaryInfoIcon = {
        let icon = SummaryInfoIcon()
        icon.tagLabel.text = "burning"
        icon.valueLabel.unit.text = "일"
        icon.icon.image = UIImage(systemName: "flame.fill")
        icon.updateColor(UIColor(rgb: 0xFD4C4C))
        return icon
    }()
    
    let settingTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        table.rowHeight = 56
        table.isScrollEnabled = false
        return table
    }()
    
    // MARK: - Initial Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auto Layout Method
    private func setupUI() {
        self.backgroundColor = .white
    }
    
    private func setupAutoLayout() {
        [headerLabel, totalInfoIcon, todayInfoIcon, burningInfoIcon].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: headerLabel.topAnchor),
            self.bottomAnchor.constraint(equalTo: todayInfoIcon.bottomAnchor, constant: 32),
            
            headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            totalInfoIcon.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            totalInfoIcon.trailingAnchor.constraint(equalTo: todayInfoIcon.leadingAnchor, constant: 0),
            
            todayInfoIcon.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            todayInfoIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            burningInfoIcon.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            burningInfoIcon.leadingAnchor.constraint(equalTo: todayInfoIcon.trailingAnchor, constant: 0)
        ])
    }
}
