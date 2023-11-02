//
//  CalendarCell.swift
//  DayBlock
//
//  Created by 김민준 on 10/31/23.
//

import Foundation
import FSCalendar

final class CalendarCell: FSCalendarCell {
    
    static let id = "CalendarCell"
    
    weak var selectionLayer: CAShapeLayer!
    
    let dateBlock: UIView = {
        let view = UIView()
        view.backgroundColor = Color.entireBlock
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        return view
    }()
    
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
        // self.backgroundColor = .systemBlue.withAlphaComponent(0.5)
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
    
    private func setupDateCircle() {
        selectedDateCircle.addSubview(selectedDateLabel)
        
        NSLayoutConstraint.activate([
            selectedDateLabel.centerXAnchor.constraint(equalTo: selectedDateCircle.centerXAnchor),
            selectedDateLabel.centerYAnchor.constraint(equalTo: selectedDateCircle.centerYAnchor)
        ])
    }
    
    private func setupAutoLayout() {
        [dateBlock, dateLabel, selectedDateCircle].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dateBlock.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dateBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateBlock.widthAnchor.constraint(equalToConstant: 24),
            dateBlock.heightAnchor.constraint(equalToConstant: 24),
            
            dateLabel.topAnchor.constraint(equalTo: dateBlock.bottomAnchor, constant: 2),
            dateLabel.centerXAnchor.constraint(equalTo: dateBlock.centerXAnchor),
            
            selectedDateCircle.topAnchor.constraint(equalTo: dateBlock.bottomAnchor, constant: 3),
            selectedDateCircle.centerXAnchor.constraint(equalTo: dateBlock.centerXAnchor),
            selectedDateCircle.widthAnchor.constraint(equalToConstant: 22),
            selectedDateCircle.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
