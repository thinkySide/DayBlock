//
//  UILabel++.swift
//  DayBlock
//
//  Created by 김민준 on 12/14/23.
//

import UIKit

extension UILabel {
    
    /// 특정 부분의 컬러를 변경하는 메서드입니다.
    func asFontColor(targetString: String, font: UIFont?, color: UIColor?, lineSpacing: CGFloat, alignment: NSTextAlignment) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        
        /// 폰트 설정
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        
        /// 문단 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        attributedText = attributedString
    }
    
    /// 행간을 조정하는 메서드입니다.
    func asLineSpacing(targetString: String, lineSpacing: CGFloat, alignment: NSTextAlignment) {
        let attrString = NSMutableAttributedString(string: targetString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        attributedText = attrString
    }
}
