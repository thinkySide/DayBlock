//
//  ToolTip.swift
//  DayBlock
//
//  Created by 김민준 on 12/28/23.
//

import UIKit

final class ToolTip: UIView {
    
    enum TipDirection {
        case top
        case bottom
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "툴팁입니다"
        label.font = UIFont(name: Pretendard.bold, size: 13)
        label.textColor = Color.mainText
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    init(text: String, tipDirection: TipDirection = .top, tipStartX: CGFloat) {
        super.init(frame: .zero)
        
        // 기본값 숨기기
        self.alpha = 1
        
        // 배경색 지정
        self.backgroundColor = .white
        
        // 라벨 지정
        self.label.text = text
        
        let path = CGMutablePath()
        let tipWidth = 11.0
        let tipHeight = 6.0
        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth
        
        if tipDirection == .top {
            path.move(to: CGPoint(x: tipStartX, y: 0))
            path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: -tipHeight))
            path.addLine(to: CGPoint(x: endXWidth, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
        
        else if tipDirection == .bottom {
            path.move(to: CGPoint(x: tipStartX, y: 30))
            path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: 30 + tipHeight))
            path.addLine(to: CGPoint(x: endXWidth, y: 30))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.white.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 12
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 30),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
