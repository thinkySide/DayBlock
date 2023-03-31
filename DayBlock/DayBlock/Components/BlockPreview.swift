//
//  BlockPreview.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/01.
//

import UIKit

final class BlockPreview: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitial()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitial() {
        backgroundColor = GrayScale.entireBlock
    }
    
}
