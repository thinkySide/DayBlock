//
//  HomeViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeViewController: UIViewController {
    
    let viewManager = HomeView()
    let timerManager = TimerManager.shared
    
    let groupData = GroupDataStore.shared
    let blockData = BlockDataStore.shared
    let trackingData = TrackingDataStore.shared
    
    // 스크롤 시작 지점 저장 변수
    lazy var startScrollX: CGFloat = 0
    
    // 현재 블럭 인덱스
    var blockIndex = 0 {
        
        // 마지막 블럭 분기
        didSet {
            if blockData.list().count == blockIndex {
                viewManager.toggleTrackingButton(false)
            } else {
                viewManager.toggleTrackingButton(true)
            }
        }
    }
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(testCoreData))
        viewManager.blockPreview.addGestureRecognizer(gesture)
        
        setupCoreData()
        setupNotification()
        setupDelegate()
        setupNavigationItem()
        setupBlockCollectionView()
        setupTimer()
        setupUI()
        setupGestrue()
        setupTrackingMode()
    }
    
    // MARK: - Setup Method
    
    /// 데이터 설정을 위한 CoreData를 불러와 Fetch합니다.
    private func setupCoreData() {
        groupData.saveContext()
        groupData.initDefaultGroup()
    }
    
    /// 처음 트래킹 모드 실행 메서드
    private func setupTrackingMode() {
        
        // 트래킹 모드 여부 확인
        let isTracking = UserDefaults.standard.object(forKey: UserDefaultsKey.isTracking) as? Bool ?? false
        let isPause = UserDefaults.standard.object(forKey: UserDefaultsKey.isPause) as? Bool ?? false
        
        // 그룹 및 블럭 인덱스 확인
        let groupIndex = UserDefaults.standard.object(forKey: UserDefaultsKey.groupIndex) as? Int ?? 0
        let blockIndex = UserDefaults.standard.object(forKey: UserDefaultsKey.blockIndex) as? Int ?? 0
        
        if isTracking {
            
            // 1. 그룹 & 블럭 인덱스 업데이트
            groupData.updateFocusIndex(to: groupIndex)
            blockData.updateFocusIndex(to: blockIndex)
            
            // 나갔다 들어온 시간
            let lastAccess = UserDefaults.standard.object(forKey: UserDefaultsKey.latestAccess) as? Int ?? 0
            // let pausedTime = UserDefaults.standard.object(forKey: UserDefaultsKey.pausedTime) as? Int ?? 0
            let elapsedTime = trackingData.todaySecondsToInt() - lastAccess

            // 1. 전체 트래킹 시간 업데이트
            let originalTotalTime = UserDefaults.standard.object(forKey: UserDefaultsKey.totalTime) as? Int ?? 0
            
            // 전체 시간 = 기존 전체 시간 + 지난 시간 - 일시정지 시간
            let totalTime = originalTotalTime + elapsedTime
            timerManager.totalTime = totalTime
            
            // 2-2. 현재 트래킹 시간 업데이트
            // 현재 시간 = 기존 전체 시간 % 타겟 숫자 + 지난 시간 - 일시정지 시간
            let currentTime = originalTotalTime % trackingData.targetSecond + elapsedTime
            timerManager.currentTime = Float(currentTime)
            
            // 3. totalBlock 업데이트
            for _ in 1...(timerManager.totalTime / trackingData.targetSecond) {
                timerManager.totalBlock += 0.5
            }
            
            // 기존 트래킹 보드 업데이트
            trackingData.testAppendForDisconnect()
            // trackingData.regenerationTrackingBlocks()
            
            // 3. 0.5개 이상의 블럭이 생산되었을 경우
            if timerManager.currentTime > Float(trackingData.targetSecond) {
                let count = Int(timerManager.currentTime / Float(trackingData.targetSecond))
                viewManager.dateLabel.text = "\(count)개의 블럭 생성!"
                timerManager.currentTime -= Float(trackingData.targetSecond) * Float(count)
                
                for _ in 1...count {
                    trackingData.appendDataBetweenBackground()
                }
                
                // 4. 생산 블럭량 라벨 업데이트
                viewManager.updateCurrentProductivityLabel(timerManager.totalBlock)
                
                // 5. 트래킹 보드 애니메이션 업데이트
                viewManager.blockPreview.refreshAnimation(trackingData.trackingBlocks(), color: groupData.focusColor())
            }
            
            // 6. 타이머 및 프로그레스 바 UI 업데이트
            viewManager.updateTracking(time: timerManager.format, progress: timerManager.progressPercent())
            
            // 7. 트래킹 모드 시작
            viewManager.trackingRestartForDisconnect()
            
            // 8. 일시정지 상태
            if isPause { viewManager.trackingButtonTapped() }
        }
    }
    
    /// NavigationBar Item을 설정합니다.
    private func setupNavigationItem() {
        let trackingStopBarButtomItem = viewManager.trackingStopBarButtonItem
        navigationItem.rightBarButtonItem = trackingStopBarButtomItem
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Color.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    /// Custom Delegate를 위임받습니다.
    private func setupDelegate() {
        viewManager.delegate = self
        viewManager.trackingBlock.delegate = self
        viewManager.blockPreview.delegate = self
    }
    
    /// 기본 UI 설정을 설정합니다.
    private func setupUI() {
        initialGroupSelectButton()
        initialTrackingStartButton()
        viewManager.productivityLabel.text = "TODAY +\(trackingData.todayAllOutput())"
    }
    
    /// 제스처를 연결하고 설정합니다.
    private func setupGestrue() {
        addTapGesture(viewManager.groupSelectButton, target: self, action: #selector(groupSelectButtonTapped))
        addTapGesture(viewManager.trackingStopBarButtonItem, target: self, action: #selector(trackingStopBarButtonItemTapped))
        configureBlockLongPressGesture()
    }
}
