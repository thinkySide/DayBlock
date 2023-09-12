//
//  DashedSeparator.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/12.
//

import UIKit

final class DashedSeparator: UIView {
    
    let stroke = CAShapeLayer()
    var dashPattern: [NSNumber]
    var height: CGFloat
    
    // MARK: - Initial Method
    
    /// DashPattern의 기본값 = [4, 4]
    /// height의 기본값 = 2
    init(frame: CGRect, dashPattern: [NSNumber] = [4, 4], height: CGFloat = 2) {
        
        // 변수 세팅 & 상위 생성 메서드 호출
        self.dashPattern = dashPattern
        self.height = height
        super.init(frame: frame)
        
        // AutoLayout Constraints
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.clipsToBounds = true
        self.layer.cornerRadius = height
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Stroke Setting
        stroke.lineWidth = height
        stroke.strokeColor = GrayScale.seperator.cgColor
        stroke.lineDashPattern = dashPattern
        stroke.frame = self.bounds
        stroke.fillColor = nil
        stroke.path = UIBezierPath(rect: self.bounds).cgPath
        
        // AddSubLayer
        self.layer.addSublayer(stroke)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
