//
//  CustomTextField.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/15.
//

import UIKit

/// 붙여넣기 비활성화용 UITextField
final class CustomUITextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
}
