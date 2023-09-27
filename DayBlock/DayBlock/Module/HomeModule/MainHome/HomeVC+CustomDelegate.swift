//
//  HomeVC+CustomDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/20.
//

import UIKit

// MARK: - Home View Delegate
extension HomeViewController: HomeViewDelegate {
    
    /// 트래킹 모드와 홈 모드가 전환 될 때, TabBar 표시 여부를 결정하는 Delegate 메서드입니다.
    ///
    /// - Parameter isDisplay: TabBar 표시 여부
    func homeView(_ homeView: HomeView, displayTabBarForTrackingMode isDisplay: Bool) {
        let value: CGFloat = isDisplay ? 1 : 0
        viewManager.tabBarStackView.alpha = value
        tabBarController?.tabBar.alpha = value
    }
    
    /// 트래킹 모드가 시작 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidStart mode: HomeView.TrakingMode) {
        
        // 1. 타이머 시작
        timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 2. 트래킹 보드 애니메이션 시작
        // activateTrackingBoard()
        
        // 현재 시간 추가 후 트래킹 블럭 리스트 반환
        trackingData.appendCurrentTimeInTrackingBlocks()
        // trackingData.printData()
        
        // 2. 트래킹 시작 날짜 데이터 넣기
        trackingData.createStartData()
        
        // 3. 현재 트래킹 중인 블럭 정보 저장
        let blockDataList = blockData.list()
        viewManager.trackingBlock.update(group: groupData.focusEntity(), block: blockDataList[blockIndex])
        
        // 4. 화면 꺼짐 방지
        isScreenCanSleep(false)
    }
    
    /// 트래킹 모드가 일시정지 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidPause mode: HomeView.TrakingMode) {
        
        // 1. 타이머 비활성화
        timerManager.trackingTimer.invalidate()
    }
    
    /// 트래킹 모드가 재시작 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidRestart mode: HomeView.TrakingMode) {
        
        // 1. 타이머 시작
        timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
    }
    
    /// 트래킹 모드가 중단 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidStop mode: HomeView.TrakingMode) {
        
        // 0. 이전에 트래킹 되고 있던 데이터 삭제
        trackingData.removeStopData()
        
        // 1. 트래커 초기화
        resetTracker()
    }
    
    /// 트래킹 모드가 완료된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidFinish mode: HomeView.TrakingMode) {
        resetTracker()
    }
    
    /// ProgressView의 컬러를 설정하기 위한 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, setupProgressViewColor mode: HomeView.TrakingMode) {
        
        // 1. 현재 그룹의 컬러를 기준으로 설정
        viewManager.setupProgressViewColor(color: groupData.focusColor())
    }
}

// MARK: - Day Block Delegate
extension HomeViewController: DayBlockDelegate {
    
    /// 트래킹 완료 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter taskLabel: 트래킹 완료된 작업 이름
    func dayBlock(_ dayBlock: DayBlock, trackingComplete taskLabel: String?) {
        
        // 0. 아직 블럭이 생성되지 않았다면, 메서드 종료
        guard timerManager.totalTime > 1800 else {
            showToast(toast: viewManager.toastView, isActive: true)
            return
        }
        
        // 1. 최종 트래킹 데이터 저장
        trackingData.createFinishData()
        
        // 2. 트래킹 완료 화면 Present
        presentTrackingCompleteVC()
        
        // 3. 홈 화면 트래킹 모드 종료
        viewManager.finishTrackingMode()
        
        // 4. 트래커 초기화
        resetTracker()
    }
}

// MARK: - Create Block ViewController Delegate
extension HomeViewController: CreateBlockViewControllerDelegate {
    
    /// 블럭 편집 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: CreateBlockViewController의 현재 모드
    func createBlockViewController(_ createBlockViewController: CreateBlockViewController, blockDidEdit mode: CreateBlockViewController.Mode) {
        
        // 1. 그룹 선택 버튼 UI 업데이트
        viewManager.groupSelectButton.color.backgroundColor = groupData.focusColor()
        viewManager.groupSelectButton.label.text = groupData.focusEntity().name
        
        // 2. 현재 인덱스 저장
        blockIndex = blockData.focusIndex()
        
        // 3. BlockCollectionView 리로드(뒤집어져 있기 때문) 및 스크롤 위치 지정
        viewManager.blockCollectionView.reloadData()
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
        
        // 4. 편집된 블럭이 포커스 되어있으므로, 트래킹 버튼 활성화
        viewManager.toggleTrackingButton(true)
    }
    
    /// 블럭 생성 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: CreateBlockViewController의 현재 모드
    func createBlockViewController(_ createBlockViewController: CreateBlockViewController, blockDidCreate mode: CreateBlockViewController.Mode) {
        
        // 1. 그룹 업데이트(그룹이 편집이 되었을 경우를 확인하기 위해)
        switchHomeGroup(index: groupData.focusIndex())
        
        // 2. 현재 블럭 인덱스를 가장 마지막 인덱스로 저장(생성 블럭 이전 인덱스)
        blockIndex = blockData.list().count - 1
        blockData.updateFocusIndex(to: blockIndex)
        
        // 3. BlockCollectionView 스크롤 위치 지정
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
        
        // 4. 생성된 블럭이 포커스 되어있으므로, 트래킹 버튼 활성화
        viewManager.toggleTrackingButton(true)
    }
}
