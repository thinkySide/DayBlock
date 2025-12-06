//
//  TimeLineBoard.swift
//  DayBlock
//
//  Created by 김민준 on 11/16/23.
//

import UIKit
 
final class TimeLineBoard: UIView {
    
    let time00 = TimeLineBlock(date: "00")
    let time01 = TimeLineBlock(date: "01")
    let time02 = TimeLineBlock(date: "02")
    let time03 = TimeLineBlock(date: "03")
    let time04 = TimeLineBlock(date: "04")
    let time05 = TimeLineBlock(date: "05")
    let time06 = TimeLineBlock(date: "06")
    let time07 = TimeLineBlock(date: "07")
    let time08 = TimeLineBlock(date: "08")
    let time09 = TimeLineBlock(date: "09")
    let time10 = TimeLineBlock(date: "10")
    let time11 = TimeLineBlock(date: "11")
    let time12 = TimeLineBlock(date: "12")
    let time13 = TimeLineBlock(date: "13")
    let time14 = TimeLineBlock(date: "14")
    let time15 = TimeLineBlock(date: "15")
    let time16 = TimeLineBlock(date: "16")
    let time17 = TimeLineBlock(date: "17")
    let time18 = TimeLineBlock(date: "18")
    let time19 = TimeLineBlock(date: "19")
    let time20 = TimeLineBlock(date: "20")
    let time21 = TimeLineBlock(date: "21")
    let time22 = TimeLineBlock(date: "22")
    let time23 = TimeLineBlock(date: "23")
    
    var blockSpacing: CGFloat = 0
    var lineSpacing: CGFloat = 0
    
    init(blockSpace: CGFloat, lineSpace: CGFloat) {
        blockSpacing = blockSpace
        lineSpacing = lineSpace
        super.init(frame: .zero)
        
        [
            time00, time01, time02, time03, time04, time05,
            time06, time07, time08, time09, time10, time11,
            time12, time13, time14, time15, time16, time17,
            time18, time19, time20, time21, time22, time23
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            self.topAnchor.constraint(equalTo: time00.topAnchor),
            self.leadingAnchor.constraint(equalTo: time00.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: time05.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: time23.bottomAnchor),
            
            // 첫째 줄
            time00.topAnchor.constraint(equalTo: topAnchor),
            time00.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            time01.topAnchor.constraint(equalTo: topAnchor),
            time01.leadingAnchor.constraint(equalTo: time00.trailingAnchor, constant: blockSpacing),
            
            time02.topAnchor.constraint(equalTo: topAnchor),
            time02.leadingAnchor.constraint(equalTo: time01.trailingAnchor, constant: blockSpacing),
            
            time03.topAnchor.constraint(equalTo: topAnchor),
            time03.leadingAnchor.constraint(equalTo: time02.trailingAnchor, constant: blockSpacing),
            
            time04.topAnchor.constraint(equalTo: topAnchor),
            time04.leadingAnchor.constraint(equalTo: time03.trailingAnchor, constant: blockSpacing),
            
            time05.topAnchor.constraint(equalTo: topAnchor),
            time05.leadingAnchor.constraint(equalTo: time04.trailingAnchor, constant: blockSpacing),
            
            // 둘째 줄
            time06.topAnchor.constraint(equalTo: time00.bottomAnchor, constant: lineSpacing),
            time06.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            time07.topAnchor.constraint(equalTo: time00.bottomAnchor, constant: lineSpacing),
            time07.leadingAnchor.constraint(equalTo: time06.trailingAnchor, constant: blockSpacing),
            
            time08.topAnchor.constraint(equalTo: time00.bottomAnchor, constant: lineSpacing),
            time08.leadingAnchor.constraint(equalTo: time07.trailingAnchor, constant: blockSpacing),
            
            time09.topAnchor.constraint(equalTo: time00.bottomAnchor, constant: lineSpacing),
            time09.leadingAnchor.constraint(equalTo: time08.trailingAnchor, constant: blockSpacing),
            
            time10.topAnchor.constraint(equalTo: time00.bottomAnchor, constant: lineSpacing),
            time10.leadingAnchor.constraint(equalTo: time09.trailingAnchor, constant: blockSpacing),
            
            time11.topAnchor.constraint(equalTo: time00.bottomAnchor, constant: lineSpacing),
            time11.leadingAnchor.constraint(equalTo: time10.trailingAnchor, constant: blockSpacing),
            
            // 셋째 줄
            time12.topAnchor.constraint(equalTo: time06.bottomAnchor, constant: lineSpacing),
            time12.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            time13.topAnchor.constraint(equalTo: time06.bottomAnchor, constant: lineSpacing),
            time13.leadingAnchor.constraint(equalTo: time12.trailingAnchor, constant: blockSpacing),
            
            time14.topAnchor.constraint(equalTo: time06.bottomAnchor, constant: lineSpacing),
            time14.leadingAnchor.constraint(equalTo: time13.trailingAnchor, constant: blockSpacing),
            
            time15.topAnchor.constraint(equalTo: time06.bottomAnchor, constant: lineSpacing),
            time15.leadingAnchor.constraint(equalTo: time14.trailingAnchor, constant: blockSpacing),
            
            time16.topAnchor.constraint(equalTo: time06.bottomAnchor, constant: lineSpacing),
            time16.leadingAnchor.constraint(equalTo: time15.trailingAnchor, constant: blockSpacing),
            
            time17.topAnchor.constraint(equalTo: time06.bottomAnchor, constant: lineSpacing),
            time17.leadingAnchor.constraint(equalTo: time16.trailingAnchor, constant: blockSpacing),
            
            // 넷째 줄
            time18.topAnchor.constraint(equalTo: time12.bottomAnchor, constant: lineSpacing),
            time18.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            time19.topAnchor.constraint(equalTo: time12.bottomAnchor, constant: lineSpacing),
            time19.leadingAnchor.constraint(equalTo: time18.trailingAnchor, constant: blockSpacing),
            
            time20.topAnchor.constraint(equalTo: time12.bottomAnchor, constant: lineSpacing),
            time20.leadingAnchor.constraint(equalTo: time19.trailingAnchor, constant: blockSpacing),
            
            time21.topAnchor.constraint(equalTo: time12.bottomAnchor, constant: lineSpacing),
            time21.leadingAnchor.constraint(equalTo: time20.trailingAnchor, constant: blockSpacing),
            
            time22.topAnchor.constraint(equalTo: time12.bottomAnchor, constant: lineSpacing),
            time22.leadingAnchor.constraint(equalTo: time21.trailingAnchor, constant: blockSpacing),
            
            time23.topAnchor.constraint(equalTo: time12.bottomAnchor, constant: lineSpacing),
            time23.leadingAnchor.constraint(equalTo: time22.trailingAnchor, constant: blockSpacing)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
