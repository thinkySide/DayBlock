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
        setupTrackingMode()
        setupNotification()
        setupDelegate()
        setupNavigationItem()
        setupBlockCollectionView()
        setupTimer()
        setupUI()
        setupGestrue()
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
        print("현재 트래킹 모드: \(isTracking), 일시정지: \(isPause)")
        
        // 그룹 및 블럭 인덱스 확인
        let groupIndex = UserDefaults.standard.object(forKey: UserDefaultsKey.groupIndex) as? Int ?? 0
        let blockIndex = UserDefaults.standard.object(forKey: UserDefaultsKey.blockIndex) as? Int ?? 0
        print("그룹 인덱스: \(groupIndex), 블럭 인덱스: \(blockIndex)\n")
        
        if isTracking {
            print("App 실행, 트래킹 모드 재시작\n")
            
            // TODO: 트래킹 모드 재시작 로직
            
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
