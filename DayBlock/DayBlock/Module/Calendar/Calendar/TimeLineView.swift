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
        label.font = UIFont(name: Pretendard.bold, size: 20)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "타임라인"
        return label
    }()
    
    let blockBoard = TimeLineBoard(blockSpace: 30, lineSpace: 10)
    
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
        
        [headerLabel, blockBoard].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: blockBoard.bottomAnchor, constant: 24),
            
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: blockBoard.time00.leadingAnchor),
            
            blockBoard.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            blockBoard.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
