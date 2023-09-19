//
//  HomeViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeViewController: UIViewController {
    
    let viewManager = HomeView()
    let blockManager = BlockManager.shared
    let trackingManager = TrackingManager.shared
    var timeTracker = Tracker()
    let customBottomModalDelegate = BottomModalDelegate()
    
    // 타이머 관련 변수(옮기기)
    var dateTimer: Timer!
    var trackingTimer: Timer!
    
    // 스크롤 시작 지점 저장 변수
    lazy var startScrollX: CGFloat = 0
    
    // 현재 블럭 인덱스
    var blockIndex = 0 {
        
        // 마지막 블럭 분기
        didSet {
            if blockManager.getCurrentBlockList().count == blockIndex {
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
    }
    
    // MARK: - Setup Method
    
    /// 데이터 설정을 위한 CoreData를 불러와 Fetch합니다.
    private func setupCoreData() {
        blockManager.fetchRequestGroupEntitiy()
        blockManager.initialSetupForCoreData()
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
    }
    
    /// 기본 UI 설정을 설정합니다.
    private func setupUI() {
        initialGroupSelectButton()
        initialTrackingStartButton()
    }
    
    /// 제스처를 연결하고 설정합니다.
    private func setupGestrue() {
        addTargetGestrue()
        configureBlockLongPressGesture()
    }
    
    // MARK: - Gestrue Method
    
    private func addTargetGestrue() {
        
    }
}

// MARK: - HomeDelegate
extension HomeViewController: HomeDelegate {
    
    func showTabBar() {
        viewManager.tabBarStackView.alpha = 1
        tabBarController?.tabBar.alpha = 1
    }
    
    func hideTabBar() {
        viewManager.tabBarStackView.alpha = 0
        tabBarController?.tabBar.alpha = 0
    }
    
    func startTracking() {
        
        // BlockPreview 애니메이션 활성화
        activateTrackingBoard()
        
        trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 블럭 업데이트
        let blockDataList = blockManager.getCurrentBlockList()
        viewManager.trackingBlock.update(group: blockManager.getCurrentGroup(),
                                                     block: blockDataList[blockIndex])
        
        // 화면 꺼짐 방지
        isScreenCanSleep(false)
    }
    
    func pausedTracking() {
        trackingTimer.invalidate()
    }
    
    func stopTracking() {
        trackingTimer.invalidate()
        viewManager.updateTracking(time: "00:00:00", progress: 0)
        timeTracker.totalTime = 0
        timeTracker.currentTime = 0
        timeTracker.totalBlock = 0

        // 컬렉션뷰 초기화
        viewManager.blockCollectionView.reloadData()
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
        
        // 화면 꺼짐 해제
        isScreenCanSleep(true)
    }
    
    /// 트래킹 중단 BarButtonItem Tap 이벤트 메서드입니다.
    func trackingStopBarButtonItemTapped() {
        viewManager.trackingButtonTapped()
        viewManager.blockPreview.pausedTrackingAnimation()
        presentStopTrackingPopup()
    }
    
    func selectGroupButtonTapped() {
        presentSelectGroupHalfModal()
    }
    
    func setupProgressViewColor() {
        viewManager.setupProgressViewColor(color: blockManager.getCurrentGroupColor())
    }
}

// MARK: - Day Block Delegate
extension HomeViewController: DayBlockDelegate {
    func storeTrackingBlock() {
        presentTrackingCompleteVC()
    }
}

// MARK: - Create Block ViewController Delegate
extension HomeViewController: CreateBlockViewControllerDelegate {
    
    func reloadCollectionView() {
        viewManager.blockCollectionView.reloadData()
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
    }
    
    /// CollectionView 업데이트
    func updateCollectionView(_ isEditMode: Bool) {
        
        // 편집 모드
        if isEditMode {
            viewManager.groupSelectButton.color.backgroundColor = blockManager.getCurrentGroupColor()
            viewManager.groupSelectButton.label.text = blockManager.getCurrentGroup().name
            viewManager.blockCollectionView.reloadData()
            let index = blockManager.getCurrentBlockIndex()
            blockIndex = index
            viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
        }
        
        // 생성 모드
        else {
            switchHomeGroup(index: blockManager.getCurrentGroupIndex())
            let lastIndex = blockManager.getLastBlockIndex()
            blockIndex = lastIndex
            blockManager.updateCurrentBlockIndex(blockIndex)
            viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .left, animated: true)
        }
        
        viewManager.toggleTrackingButton(true)
    }
}
