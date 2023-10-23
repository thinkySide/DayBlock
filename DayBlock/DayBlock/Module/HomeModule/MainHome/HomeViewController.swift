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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 트래킹 버튼 토글
        var isToggle = false
        isToggle = groupData.focusEntity().blockList?.count == 0 ? false : true
        viewManager.toggleTrackingButton(isToggle)
        
        // CollectionView 리로드
        viewManager.blockCollectionView.reloadData()
        
        // TabBar 설정
        let tbAppearance = UITabBarAppearance()
        tbAppearance.configureWithOpaqueBackground()
        tbAppearance.backgroundColor = .clear
        tbAppearance.shadowColor = .clear
        tabBarController?.tabBar.standardAppearance = tbAppearance
        if #available(iOS 15.0, *) {
            tabBarController?.tabBar.scrollEdgeAppearance = tbAppearance
        }
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
        
        // 1. 만약 트래킹 중이라면~
        if isTracking {
            
            // 2. 마지막으로 앱을 종료한 시점 구하기
            let lastAccess = UserDefaults.standard.object(forKey: UserDefaultsKey.latestAccess) as? Int ?? 0
            
            // 3. (현재 시간 - 마지막 종료 시점) -> 얼마나 앱이 종료되었는지 구할 수 있음
            let elapsedTime = trackingData.todaySecondsToInt() - lastAccess
            // let pausedTime = UserDefaults.standard.object(forKey: UserDefaultsKey.pausedTime) as? Int ?? 0

            // 4. 앱 종료 전 총 트래킹 시간 구하기
            let originalTotalTime = UserDefaults.standard.object(forKey: UserDefaultsKey.totalTime) as? Int ?? 0
            
            // 5. 최종 시간 = 기존 전체 시간 + 지난 시간
            let newTotalTime = originalTotalTime + elapsedTime
            timerManager.totalTime = newTotalTime
            
            // 6. 그럼 현재 트래킹 세션은 얼마나 진행되었는가?
            //    현재 시간 = 최종 시간 % 타겟 숫자
            let currentTime = newTotalTime % trackingData.targetSecond
            timerManager.currentTime = Float(currentTime)
            
            // 8. totalBlock 업데이트
            timerManager.totalBlock = Double(timerManager.totalTime / trackingData.targetSecond) * 0.5

            // 9. 몇개의 블럭이 생성되었는지 확인
            var count = 0
            if let timeList = trackingData.focusDate().trackingTimeList {
                count = (timerManager.totalTime / trackingData.targetSecond) - timeList.count
                // viewManager.dateLabel.text = "count: \(count)"
            }
            
            // 11. 블럭이 생성된 만큼 데이터 추가(0보다 클 때만)
            if count >= 0 {
                for _ in 0...count {
                    trackingData.appedDataBetweenAppDisconect()
                }
            }
            
            // 12. 생산 블럭량 라벨 업데이트
            viewManager.updateCurrentProductivityLabel(timerManager.totalBlock)
            
            // 13. 추가된 데이터로 트래킹 보드 리스트 업데이트
            trackingData.testAppendForDisconnect() // 테스트 코드
            // trackingData.regenerationTrackingBlocks() // 원래 코드
            
            // 14. 트래킹 보드 애니메이션 업데이트
            viewManager.blockPreview.refreshAnimation(trackingData.trackingBlocks(), color: groupData.focusColor())
            
            // 15. 타이머 및 프로그레스 바 UI 업데이트
            viewManager.updateTracking(time: timerManager.format, progress: timerManager.progressPercent())
            
            // 16. 트래킹 모드 시작
            viewManager.trackingRestartForDisconnect()

            // 17. 일시정지 상태
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
