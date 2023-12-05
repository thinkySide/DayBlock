//
//  SummaryTableViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import UIKit

final class SummaryTableViewCell: UITableViewCell {
    
    static let id = "SummaryTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
