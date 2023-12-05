//
//  TimeLineBlock.swift
//  DayBlock
//
//  Created by 김민준 on 11/16/23.
//

import UIKit

final class TimeLineBlock: UIView {
    
    let iconBlock: SimpleIconBlock!
    
    let configurationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xE8E8E8)
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.alpha = 0
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.font = UIFont(name: Poppins.bold, size: 14)
        label.textColor = UIColor(rgb: 0x878787)
        label.textAlignment = .center
        return label
    }()
    
    init(date: String, size: CGFloat = 32) {
        dateLabel.text = date
        iconBlock = SimpleIconBlock(size: size)
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - AutoLayout Method
    private func setupUI() {
        [iconBlock, configurationView, dateLabel].forEach {
            addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: iconBlock.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: iconBlock.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            
            iconBlock.topAnchor.constraint(equalTo: topAnchor),
            iconBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            configurationView.topAnchor.constraint(equalTo: iconBlock.topAnchor),
            configurationView.leadingAnchor.constraint(equalTo: iconBlock.leadingAnchor),
            configurationView.trailingAnchor.constraint(equalTo: iconBlock.trailingAnchor),
            configurationView.bottomAnchor.constraint(equalTo: iconBlock.bottomAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: iconBlock.bottomAnchor, constant: 2),
            dateLabel.centerXAnchor.constraint(equalTo: iconBlock.centerXAnchor)
        ])
    }
}
