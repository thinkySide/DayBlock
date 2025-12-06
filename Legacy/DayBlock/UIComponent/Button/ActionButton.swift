//
//  ConfirmButton.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/16.
//

import UIKit

final class ActionButton: UIButton {
    
    enum Mode {
        case confirm
        case cancel
        case delete
    }
    
    // MARK: - Initial
    
    init(frame: CGRect, mode: Mode) {
        super.init(frame: frame)
        
        switch mode {
        case .confirm:
            self.setBackgroundColor(Color.mainText, for: .normal)
            self.titleLabel?.font = UIFont(name: Pretendard.semiBold, size: 17)
            self.setTitleColor(.white, for: .normal)
            self.setTitle("확인", for: .normal)
            
        case .cancel:
            self.setBackgroundColor(Color.cancelButton, for: .normal)
            self.setBackgroundColor(Color.entireBlock, for: .highlighted)
            self.titleLabel?.font = UIFont(name: Pretendard.semiBold, size: 17)
            self.setTitleColor(Color.subText, for: .normal)
            self.setTitle("취소", for: .normal)
        
        case .delete:
            self.setBackgroundColor(Color.cancelButton, for: .normal)
            self.setBackgroundColor(Color.entireBlock, for: .highlighted)
            self.titleLabel?.font = UIFont(name: Pretendard.semiBold, size: 17)
            self.setTitleColor(UIColor(rgb: 0xD23939), for: .normal)
            self.setTitle("삭제하기", for: .normal)
        }

        /// Corener Raduis
        self.clipsToBounds = true
        self.layer.cornerRadius = 13
        
        /// Size
        self.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
