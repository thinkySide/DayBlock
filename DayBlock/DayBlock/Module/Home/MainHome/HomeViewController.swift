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
    let trackingBoardService = TrackingBoardService.shared
    
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
        setupCoreData()
        setupNotification()
        setupDelegate()
        setupNavigationItem()
        setupBlockCollectionView()
        setupTimer()
        setupUI()
        setupGestrue()
        setupTrackingMode()
        setupOnboarding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 기본 탭바 설정
        configureTabBar()
        
        // 트래킹 버튼 토글
        configureTrackingButton()
        
        // UI 업데이트
        uptodateTodayLabelUI()
        if !UserDefaultsItem.shared.isPaused {
            updateTrackingBoardUI()
        }
        
        // CollectionView 리로드
        viewManager.blockCollectionView.reloadData()
    }
    
    // MARK: - Setup Method
    
    /// 데이터 설정을 위한 CoreData를 불러와 Fetch합니다.
    private func setupCoreData() {
        groupData.saveContext()
        groupData.initDefaultGroup()
    }
    
    /// 처음 트래킹 모드 실행 메서드
    private func setupTrackingMode() {
        
        // 트래킹 모드 O
        if UserDefaultsItem.shared.isTracking {
            
            setTrackingModeAfterAppRestart()
            
            // 일시정지 상태
            if UserDefaultsItem.shared.isPaused { viewManager.trackingButtonTapped() }
        }
        
        // 트래킹 모드 X
        else if !UserDefaultsItem.shared.isTracking {
            blockData.updateFocusIndex(to: 0)
        }
    }
    
    /// NavigationBar Item을 설정합니다.
    private func setupNavigationItem() {
        configureBackButton()
        let helpBarButtomItem = viewManager.helpBarButtonItem
        let trackingStopBarButtomItem = viewManager.trackingStopBarButtonItem
        navigationItem.rightBarButtonItems = [trackingStopBarButtomItem, helpBarButtomItem]
    }
    
    /// Custom Delegate를 위임받습니다.
    private func setupDelegate() {
        viewManager.delegate = self
        viewManager.trackingBlock.delegate = self
    }
    
    /// 기본 UI 설정을 설정합니다.
    private func setupUI() {
        initialGroupSelectButton()
        initialTrackingStartButton()
    }
    
    /// 제스처를 연결하고 설정합니다.
    private func setupGestrue() {
        
        addTapGesture(
            viewManager.groupSelectButton,
            target: self,
            action: #selector(groupSelectButtonTapped)
        )
        
        addTapGesture(
            viewManager.helpBarButtonItem,
            target: self,
            action: #selector(helpBarButtonItemTapped)
        )
        
        addTapGesture(
            viewManager.trackingStopBarButtonItem,
            target: self,
            action: #selector(trackingStopBarButtonItemTapped)
        )
        
        configureBlockLongPressGesture()
    }
    
    /// APP 초기 실행 시, 온보딩 화면을 출력합니다.
    private func setupOnboarding() {
        
        // 만약 첫 실행이라면, 시작 화면으로 이동
        if UserDefaultsItem.shared.isFirstLaunch {
            let startVC = StartViewController()
            startVC.modalPresentationStyle = .fullScreen
            present(startVC, animated: false)
        }
    }
}
