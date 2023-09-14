//
//  HomeViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeViewController: UIViewController {
    
    var observation: NSKeyValueObservation?
    
    // MARK: - Manager
    
    private let viewManager = HomeView()
    private let blockManager = BlockManager.shared
    private let trackingManager = TrackingManager.shared
    private var timeTracker = TimeTracker()
    private let customBottomModalDelegate = BottomModalDelegate()
    
    
    // MARK: - Component
    
    private var dateTimer: Timer!
    private var trackingTimer: Timer!
    
    /// 현재 블럭 인덱스
    private var blockIndex = 0 {
        
        /// 마지막 블럭 분기
        didSet {
            if blockManager.getCurrentBlockList().count == blockIndex {
                viewManager.toggleTrackingButton(false)
            } else {
                viewManager.toggleTrackingButton(true)
            }
        }
    }
    
    private lazy var startScrollX: CGFloat = 0
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        super.loadView()
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotification()
        setupCoreData()
        setupNavigation()
        setupDelegate()
        setupContentInset()
        setupGroupSelectButton()
        setupTimer()
        setupContentsBlock()
        setupTrackingButton()
        setupDefaultFocus()
    }
    
    
    // MARK: - UserDefaults & NotificationCenter
    
    /// UserDefault를 사용한 초기 화면의 그룹 선택값을 설정합니다.
    private func setupDefaultFocus() {
        let groupIndex = UserDefaults.standard.object(forKey: UD.groupIndex) as? Int ?? 0
        switchHomeGroup(index: groupIndex)
        blockManager.updateCurrentGroup(index: groupIndex)
    }
    
    /// Notification 등록
    private func setupNotification() {
        
        // 블럭 삭제 observer
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForDeleteBlock), name: NSNotification.Name(Noti.reloadForDeleteBlock), object: nil)
        
        // 블럭 편집 observer
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForUpdateBlock), name: NSNotification.Name(Noti.reloadForUpdateBlock), object: nil)
    }
    
    /// 블럭 삭제 Noti를 받았을 때 실행할 메서드
    @objc func reloadForDeleteBlock(_ notification: Notification) {
        switchHomeGroup(index: 0)
        
        // TODO: 그룹 초기화 기능 ⛳️
        // 만약 첫 화면의 그룹이 삭제가 되었다면 0번째 인덱스로 전환하고
        // 삭제가 안되었다면 현재 인덱스 그대로 유지(요건 코드 굳이 작성안해줘도 될듯)
    }
    
    // 블럭 편집 Noti를 받았을 때 실행할 메서드
    @objc func reloadForUpdateBlock(_ notification: Notification) {
        let currentGroup = blockManager.getCurrentGroup()
        viewManager.groupSelectButton.label.text = currentGroup.name
        viewManager.groupSelectButton.color.backgroundColor = UIColor(rgb: currentGroup.color)
        viewManager.blockCollectionView.reloadData()
    }
    
    
    // MARK: - Setup Method
    
    func setupCoreData() {
        blockManager.fetchRequestGroupEntitiy()
        blockManager.initialSetupForCoreData()
    }
    
    func setupNavigation() {
        
        // TrackingStopButton
        let trackingStopBarButtomItem = viewManager.trackingStopBarButtonItem
        navigationItem.rightBarButtonItem = trackingStopBarButtomItem
        
        // 뒤로가기 버튼
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = GrayScale.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func setupDelegate() {
        
        // HomeView
        viewManager.delegate = self
        
        // blockCollectionView
        viewManager.blockCollectionView.dataSource = self
        viewManager.blockCollectionView.delegate = self
        viewManager.blockCollectionView.register(HomeBlockCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: Cell.block)
        
        // trackingBlock
        viewManager.trackingBlock.delegate = self
    }
    
    func setupContentInset() {
        
        /// (전체 화면 가로 사이즈 - 블럭 가로 사이즈) / 2
        let inset: CGFloat = (UIScreen.main.bounds.width - Size.blockSize.width) / 2.0
        
        /// 왼쪽과 오른쪽에 inset만큼 떨어트리기
        let contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        /// CollectionView의 contentInset 설정
        viewManager.blockCollectionView.contentInset = contentInset
    }
    
    func setupGroupSelectButton() {
        if blockManager.getGroupList().count == 0 { return }
        viewManager.groupSelectButton.color.backgroundColor = blockManager.getCurrentGroupColor()
    }
    
    func setupTimer() {
        updateDate()
        updateTime()
        
        /// 날짜 및 시간 업데이트용 타이머 설정
        dateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func setupContentsBlock() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(trackingBlockLongPressed))
        longPressGesture.minimumPressDuration = 0.1 // 제스처 시작까지 걸리는 최소 수
        viewManager.trackingBlock.addGestureRecognizer(longPressGesture)
    }
    
    func setupTrackingButton() {
        if blockManager.getCurrentBlockList().count == 0 {
            viewManager.toggleTrackingButton(false)
        }
    }
    
    
    // MARK: - Custom Method
    
    /// 현재 시간 업데이트
    @objc func updateTime() {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "HH:mm"
        viewManager.timeLabel.text = timeFormatter.string(from: Date())
        
        let trackingFormatter = DateFormatter()
        trackingFormatter.locale = Locale(identifier: "ko_KR")
        trackingFormatter.dateFormat = "HH/mm/ss"
        
        // 트래킹 타임 업데이트
        trackingManager.updateTrackingStartTime(trackingFormatter.string(from: Date()))
        
        // 00:00에 날짜 업데이트
        if viewManager.timeLabel.text == "00:00" { updateDate() }
    }
    
    /// 현재 날짜 및 요일 업데이트
    func updateDate() {
        viewManager.dateLabel.text = trackingManager.dateFormat
    }
    
    /// 트래킹 블럭 Long Press Gestrue
    @objc func trackingBlockLongPressed(_ gesture: UILongPressGestureRecognizer) {
        let state = gesture.state
        
        // Gesture 시작
        if state == .began {
            print("제스처 시작")
            viewManager.trackingBlock.animation(isFill: true)
        }
        
        // Gestrue 종료
        if state == .ended {
            print("제스처 종료")
            viewManager.trackingBlock.animation(isFill: false)
        }
        
        // 가끔 화면이 Present되면서 정상적으로 종료되지 않고 취소 되는 경우 있음. (예외처리)
        if state == .cancelled {
            print("제스처 취소")
            viewManager.trackingBlock.animation(isFill: false)
        }
    }
}


// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockManager.getCurrentBlockList().count + 1 /// 블럭 추가 버튼 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewManager.blockCollectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.block, for: indexPath) as! HomeBlockCollectionViewCell
        let index = indexPath.row
        let blockDataList = blockManager.getCurrentBlockList()
        cell.reverseDirectionWithNoAnimation()
        
        // TODO: 삭제 및 편집 기능 추가(코어데이터)
        
        // 삭제 제스처
        cell.trashButtonTapped = { [weak self] _ in
            
            let deletePopup = DeletePopupViewController()
            deletePopup.delegate = self
            deletePopup.modalPresentationStyle = .overCurrentContext
            deletePopup.modalTransitionStyle = .crossDissolve
            self?.present(deletePopup, animated: true)
        }
        
        // 편집 제스처
        cell.editButtonTapped = { [weak self] sender in
            guard let self else { return }
            let editBlockVC = CreateBlockViewController()
            editBlockVC.delegate = self
            editBlockVC.hidesBottomBarWhenPushed = true
            
            // RemoteBlock 업데이트
            let editBlock = blockDataList[index]
            blockManager.updateRemoteBlock(group: blockManager.getCurrentGroup())
            blockManager.updateRemoteBlock(label: editBlock.taskLabel)
            blockManager.updateRemoteBlock(output: editBlock.output)
            blockManager.updateRemoteBlock(icon: editBlock.icon)
            blockManager.updateCurrentBlockIndex(index)
            editBlockVC.setupEditMode()
            
            navigationController?.pushViewController(editBlockVC, animated: true)
        }
        
        // 초기 상태
        if blockDataList.count == 0 {
            cell.plusLabel.isHidden = true
            cell.totalProductivityLabel.isHidden = true
            cell.blockColorTag.isHidden = true
            cell.blockLabel.isHidden = true
            cell.blockIcon.image = UIImage(systemName: "plus.circle.fill")
            cell.blockIcon.tintColor = GrayScale.addBlockButton
            cell.backgroundColor = .white
            cell.stroke.isHidden = false
            return cell
        }
        
        /// 일반 블럭 생성
        if index+1 <= blockDataList.count {
            cell.plusLabel.textColor = blockManager.getCurrentGroupColor()
            cell.totalProductivityLabel.text = "\(blockDataList[index].output)"
            cell.blockColorTag.backgroundColor = blockManager.getCurrentGroupColor()
            cell.blockIcon.image = UIImage(systemName: blockDataList[index].icon)
            cell.blockLabel.text = blockDataList[index].taskLabel
            cell.stroke.isHidden = true
            return cell
        }
        
        /// 블럭 추가 버튼
        else {
            cell.plusLabel.isHidden = true
            cell.totalProductivityLabel.isHidden = true
            cell.blockColorTag.isHidden = true
            cell.blockLabel.isHidden = true
            cell.blockIcon.image = UIImage(systemName: "plus.circle.fill")
            cell.blockIcon.tintColor = GrayScale.addBlockButton
            cell.backgroundColor = .white
            cell.stroke.isHidden = false
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeBlockCollectionViewCell else {
            print("셀 생성 실패")
            return
        }
        let currentIndex = indexPath.item
        let count = blockManager.getCurrentBlockList().count
        
        // 현재 보고있는 블럭만 활성화
        if currentIndex != blockManager.getCurrentBlockIndex() {
            print("현재 보고 있는 블럭 X")
            return
        }
        
        // 블럭 토글 이벤트
        if cell.blockIcon.alpha == 0 {
            cell.reverseDirection(.front)
        } else {
            cell.reverseDirection(.back)
        }
        
        // 블럭 클릭 이벤트
        if blockIndex == currentIndex {
            
            // 마지막 블럭이라면 AddBlockViewController 화면 이동
            if count == currentIndex {
                cell.reverseDirection(.last)
                viewManager.toggleTrackingButton(false)
                let createBlockVC = CreateBlockViewController()
                createBlockVC.delegate = self
                createBlockVC.hidesBottomBarWhenPushed = true
                createBlockVC.setupCreateMode()
                navigationController?.pushViewController(createBlockVC, animated: true)
            }
        }
    }
}


// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // 스크롤 시작 지점
        startScrollX = scrollView.contentOffset.x
        
        // 멀티 터치 비활성화
        scrollView.isUserInteractionEnabled = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 블럭 크기 = 블럭 가로 사이즈 + 블럭 여백 (보이는 영역 보다 크게 사이즈를 잡아야 캐러셀 구현 가능)
        let blockWidth = Size.blockSize.width + Size.blockSpacing // 180 + 32 = 212
        
        // 스크롤된 크기 = 스크롤이 멈춘 x좌표 + 스크롤뷰 inset
        let scrollSize = targetContentOffset.pointee.x + scrollView.contentInset.left
        
        // 이전 블럭 인덱스 저장
        let rememberBlockIndex = blockIndex
        
        // 블럭 한칸 이상을 갔느냐 못갔느냐 체크
        let scrollSizeCheck = abs(startScrollX - targetContentOffset.pointee.x)
        
        // 1. 한칸만 이동하는 제스처
        if scrollSizeCheck <= blockWidth {
            
            // 왼쪽으로 한칸 이동하는 경우 (제스처 보정용 -30)
            if startScrollX-30 > targetContentOffset.pointee.x && blockIndex > 0 {
                blockIndex -= 1
            }
            
            // 오른쪽으로 한칸 이동하는 경우 (제스처 보정용 +30)
            if startScrollX+30 < targetContentOffset.pointee.x && blockIndex < blockManager.getCurrentBlockList().count {
                blockIndex += 1
            }
        }
        
        // 2. 한칸 이상 이동하는 제스처
        else { blockIndex = Int(round(scrollSize / blockWidth)) }
        
        // 최종 스크롤 위치 지정
        targetContentOffset.pointee = CGPoint(x: CGFloat(blockIndex) * blockWidth - scrollView.contentInset.left,
                                              y: scrollView.contentInset.top)
        
        // 사용자 터치 재활성화
        scrollView.isUserInteractionEnabled = true
        
        // 블럭 인덱스 업데이트
        if blockIndex != rememberBlockIndex {
            viewManager.blockCollectionView.reloadData()
        }
        blockManager.updateCurrentBlockIndex(blockIndex)
    }
}


// MARK: - HomeViewDelegate

extension HomeViewController: HomeDelegate {
    
    /// 트래킹 중단 BarButtonItem Tap 이벤트 메서드
    func trackingStopBarButtonItemTapped() {
        
        // 트래킹 일시 중지
        viewManager.trackingButtonTapped()
        
        // 블럭 프리뷰 애니메이션 일시 중지
        viewManager.blockPreview.pausedTrackingAnimation()
        
        // 팝업 출력
        let deletePopup = DeletePopupViewController()
        deletePopup.deletePopupView.mainLabel.text = "블럭 생산을 중단할까요?"
        deletePopup.deletePopupView.subLabel.text = "지금까지 생산한 블럭이 모두 사라져요."
        deletePopup.deletePopupView.actionStackView.confirmButton.setTitle("중단할래요", for: .normal)
        deletePopup.modalPresentationStyle = .overCurrentContext
        deletePopup.modalTransitionStyle = .crossDissolve
        
        // 이벤트 메서드 연결
        deletePopup.deletePopupView.actionStackView.confirmButton.addTarget(self, action: #selector(trackingModeDeletePopupConfirmButtonTapped), for: .touchUpInside)
        deletePopup.deletePopupView.actionStackView.cancelButton.addTarget(self, action: #selector(trackingModeDeletePopupCancelButtonTapped), for: .touchUpInside)
        
        self.present(deletePopup, animated: true)
    }
    
    func selectGroupButtonTapped() {
        let selectGroupVC = SelectGroupViewController()
        selectGroupVC.delegate = self
        
        // Half-Modal 설정
        if #available(iOS 15.0, *) {
            selectGroupVC.modalPresentationStyle = .pageSheet
            if let sheet = selectGroupVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
        } else {
            selectGroupVC.modalPresentationStyle = .custom
            selectGroupVC.transitioningDelegate = customBottomModalDelegate
        }
        
        present(selectGroupVC, animated: true)
    }
    
    func startTracking() {
        
        // BlockPreview 애니메이션 활성화
        activateBlockPreview()
        
        trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTrackingTime), userInfo: nil, repeats: true)
        
        // 블럭 업데이트
        let blockDataList = blockManager.getCurrentBlockList()
        viewManager.trackingBlock.setupBlockContents(group: blockManager.getCurrentGroup(),
                                                     block: blockDataList[blockIndex])
        
        // 화면 꺼짐 방지
        UIApplication.shared.isIdleTimerDisabled = true
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

        // ⛳️ 블럭 프리뷰 애니메이션 종료
        

        // 화면 꺼짐 해제
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    /// 1초마다 실행되는 메서드
    @objc func updateTrackingTime() {
        timeTracker.totalTime += 1
        timeTracker.currentTime += 1
        
        // 30분 단위 블럭 추가 및 현재 시간 초기화 (0.5블럭)
        if timeTracker.totalTime % 1800 == 0 {
            timeTracker.totalBlock += 0.5
            viewManager.updateCurrentProductivityLabel(timeTracker.totalBlock)
            timeTracker.currentTime = 0
            
            // 블럭 프리뷰 업데이트
            activateBlockPreview()
        }
        
        // TimeLabel & ProgressView 업데이트
        viewManager.updateTracking(time: timeTracker.timeFormatter,
                                   progress: timeTracker.currentTime / 1800)
    }
    
    /// 블럭 프리뷰 상태를 활성화하고 애니메이션을 실행합니다.
    func activateBlockPreview() {
        guard let trackingIndexs = trackingManager.fetchTrackingBlocks()[trackingManager.trackingFormat] else { return }
        let color = blockManager.getCurrentGroupColor()
        viewManager.blockPreview.activateTrackingAnimation(trackingIndexs, color: color)
    }
    
    func showTabBar() {
        viewManager.tabBarStackView.alpha = 1
        tabBarController?.tabBar.alpha = 1
    }
    
    func hideTabBar() {
        viewManager.tabBarStackView.alpha = 0
        tabBarController?.tabBar.alpha = 0
    }
    
    func setupProgressViewColor() {
        viewManager.setupProgressViewColor(color: blockManager.getCurrentGroupColor())
    }
}


// MARK: - ContentsBlockDelegate

extension HomeViewController: DayBlockDelegate {
    func storeTrackingBlock() {
        let trackingCompleteVC = TrackingCompleteViewController()
        trackingCompleteVC.delegate = self
        trackingCompleteVC.modalTransitionStyle = .coverVertical
        trackingCompleteVC.modalPresentationStyle = .overFullScreen
        present(trackingCompleteVC, animated: true)
    }
}


extension HomeViewController: TrackingCompleteViewControllerDelegate {
    
    /// 트래킹 모드 종료 델리게이트
    func endTrackingMode() {
        
        // 블럭 프리뷰 애니메이션 종료
        viewManager.blockPreview.stopTrackingAnimation()
        
        // 블럭 프리뷰 배열 초기화
        viewManager.blockPreview.resetCurrentBlocks()
        
        // 트래킹 Dictionary 초기화
        trackingManager.resetTrackingBlocks()
        
        // 트래킹 모드 종료
        viewManager.switchToHomeMode()
    }
}


// MARK: - CreateBlockViewControllerDelegate

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

// MARK: - SelectGroupViewControllerDelegate

extension HomeViewController: SelectGroupViewControllerDelegate {
    
    // 그룹 업데이트
    func switchHomeGroup(index: Int) {
        blockManager.updateCurrentGroup(index: index)
        viewManager.groupSelectButton.color.backgroundColor = blockManager.getCurrentGroupColor()
        viewManager.groupSelectButton.label.text = blockManager.getCurrentGroup().name
        viewManager.blockCollectionView.reloadData()
        
        // 스크롤 위치 초기화
        blockIndex = 0
        blockManager.updateCurrentBlockIndex(0)
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        
        // UserDefaults에 현재 그룹 인덱스 저장
        UserDefaults.standard.set(index, forKey: UD.groupIndex)
        
        // 그룹 리스트가 비어있을 시, 트래킹 버튼 비활성화
        let blockList = blockManager.getCurrentGroup().blockList?.array as! [BlockEntity]
        if blockList.isEmpty {
            viewManager.toggleTrackingButton(false)
        } else {
            viewManager.toggleTrackingButton(true)
        }
    }
}


// MARK: - DeletePopupViewControllerDelegate

extension HomeViewController: DeletePopupViewControllerDelegate {
    func confirmButtonTapped() {
        let deleteBlock = blockManager.getCurrentBlockList()[blockManager.getCurrentBlockIndex()]
        blockManager.deleteBlockEntitiy(deleteBlock)
        viewManager.blockCollectionView.reloadData()
        
        /// 그룹 리스트가 비어있을 시, 트래킹 버튼 비활성화
        let blockList = blockManager.getCurrentGroup().blockList?.array as! [BlockEntity]
        if blockList.isEmpty || (blockManager.getCurrentBlockIndex() == blockList.count) {
            viewManager.toggleTrackingButton(false)
        } else {
            viewManager.toggleTrackingButton(true)
        }
    }
    
    /// 트래킹 모드 블럭 생산 중단 팝업 - 중단할래요 버튼 탭 메서드
    @objc func trackingModeDeletePopupConfirmButtonTapped() {
        endTrackingMode()
    }
    
    /// 트래킹 모드 블럭 생산 중단 팝업 - 아니오 버튼 탭 메서드
    @objc func trackingModeDeletePopupCancelButtonTapped() {
        viewManager.trackingButtonTapped()
    }
}
