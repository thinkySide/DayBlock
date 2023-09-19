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
        addTapGesture(viewManager.groupSelectButton, target: self, action: #selector(groupSelectButtonTapped))
        addTapGesture(viewManager.trackingStopBarButtonItem, target: self, action: #selector(trackingStopBarButtonItemTapped))
        configureBlockLongPressGesture()
    }
}

// MARK: - HomeDelegate
extension HomeViewController: HomeViewDelegate {
    
    /// 트래킹 모드와 홈 모드가 전환 될 때, TabBar 표시 여부를 결정하는 Delegate 메서드입니다.
    ///
    /// - Parameter isDisplay: TabBar 표시 여부
    func homeView(_ homeView: HomeView, displayTabBarForTrackingMode isDisplay: Bool) {
        let value: CGFloat = isDisplay ? 1 : 0
        viewManager.tabBarStackView.alpha = value
        tabBarController?.tabBar.alpha = value
    }
    
    // TODO: 위에 방식으로 커스텀 델리게이트 가독성 좋게 바꾸기
    
    func startTracking() {
        
        // BlockPreview 애니메이션 활성화
        activateTrackingBoard()
        
        trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 블럭 업데이트
        let blockDataList = blockManager.getCurrentBlockList()
        viewManager.trackingBlock.update(group: blockManager.getCurrentGroup(), block: blockDataList[blockIndex])
        
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
