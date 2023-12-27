//
//  HomeVC+UpdateUI.swift
//  DayBlock
//
//  Created by 김민준 on 12/23/23.
//

import UIKit

extension HomeViewController {
    
    /// 트래킹 버튼의 ON/OFF 상태를 결정합니다.
    func configureTrackingButton() {
        let blockCount = groupData.focusEntity().blockList?.count
        let bool = blockCount == 0 || blockCount == blockData.focusIndex() ? false : true
        viewManager.toggleTrackingButton(bool)
    }
    
    /// today 라벨을 최신화합니다.
    func uptodateTodayLabelUI() {
        viewManager.productivityLabel.text = "today +\(trackingData.todayAllOutput())"
    }
    
    /// 트래킹 보드를 최신화합니다.
    func updateTrackingBoardUI() {
//        TrackingBoardService.shared.updateColor(to: 300, color: Color.testBlue)
//        TrackingBoardService.shared.updateAnimated(to: 300, isAnimated: true)
//        
//        TrackingBoardService.shared.updateColor(to: 5400, color: Color.testPink)
//        
//        TrackingBoardService.shared.updateColor(to: 7300, color: Color.testGreen)
//        
//        TrackingBoardService.shared.updateColor(to: 9100, color: Color.testYellow)
//        TrackingBoardService.shared.updateAnimated(to: 9100, isAnimated: true)
        
        viewManager.trackingBoard.updateBoard()
    }
}
