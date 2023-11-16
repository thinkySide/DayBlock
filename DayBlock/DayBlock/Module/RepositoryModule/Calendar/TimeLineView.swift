//
//  TimeLineView.swift
//  DayBlock
//
//  Created by 김민준 on 11/16/23.
//

import UIKit

final class TimeLineView: UIView {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 20)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "타임라인"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AutoLayout Method
    private func setupUI() {
        backgroundColor = .white
        
        [headerLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
}
