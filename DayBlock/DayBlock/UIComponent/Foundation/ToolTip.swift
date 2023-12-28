//
//  ToolTip.swift
//  DayBlock
//
//  Created by 김민준 on 12/28/23.
//

import UIKit

final class ToolTip: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "툴팁입니다"
        label.font = UIFont(name: Pretendard.bold, size: 13)
        label.textColor = Color.mainText
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    init(text: String, tipStartX: CGFloat) {
        super.init(frame: .zero)
        
        // 기본값 숨기기
        self.alpha = 0
        
        // 배경색 지정
        self.backgroundColor = .white
        
        // 라벨 지정
        self.label.text = text
        
        let path = CGMutablePath()
        let tipWidth = 11.0
        let tipHeight = 6.0
        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth
        
        path.move(to: CGPoint(x: tipStartX, y: 0))
        path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: -tipHeight))
        path.addLine(to: CGPoint(x: endXWidth, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.white.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 12
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
