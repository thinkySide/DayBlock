//
//  CalendarCell.swift
//  DayBlock
//
//  Created by 김민준 on 10/31/23.
//

import Foundation
import FSCalendar

final class CalendarCell: FSCalendarCell {
    
    /// 현재 셀 상태
    var state: CalendarCellState = .none
    
    static let id = "CalendarCell"
    
    let block = CalendarBlock(state: .none)
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 13)
        label.textColor = UIColor(rgb: 0x878787)
        label.textAlignment = .center
        label.text = "00"
        return label
    }()
    
    let selectedDateCircle: UIView = {
        let circle = UIView()
        circle.backgroundColor = UIColor(rgb: 0x585858)
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 11
        circle.alpha = 0
        return circle
    }()
    
    let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 13)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        setupDateCircle()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func configureAppearance() {
        super.configureAppearance()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedDateCircle.alpha = 1
            }
            
            else {
                selectedDateCircle.alpha = 0
            }
        }
    }
    
    private func setupDateCircle() {
        selectedDateCircle.addSubview(selectedDateLabel)
        
        NSLayoutConstraint.activate([
            selectedDateLabel.centerXAnchor.constraint(equalTo: selectedDateCircle.centerXAnchor),
            selectedDateLabel.centerYAnchor.constraint(equalTo: selectedDateCircle.centerYAnchor)
        ])
        
        self.shapeLayer.fillColor = UIColor.systemRed.cgColor
    }
    
    private func setupAutoLayout() {
        [block, dateLabel, selectedDateCircle].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            block.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            block.centerXAnchor.constraint(equalTo: centerXAnchor),
            block.widthAnchor.constraint(equalToConstant: 24),
            block.heightAnchor.constraint(equalToConstant: 24),
            
            dateLabel.topAnchor.constraint(equalTo: block.bottomAnchor, constant: 2),
            dateLabel.centerXAnchor.constraint(equalTo: block.centerXAnchor),
            
            selectedDateCircle.topAnchor.constraint(equalTo: block.bottomAnchor, constant: 3),
            selectedDateCircle.centerXAnchor.constraint(equalTo: block.centerXAnchor),
            selectedDateCircle.widthAnchor.constraint(equalToConstant: 22),
            selectedDateCircle.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
