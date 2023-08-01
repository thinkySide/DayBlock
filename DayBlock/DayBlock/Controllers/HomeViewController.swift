//
//  HomeViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Manager
    
    private let viewManager = HomeView()
    private let blockManager = BlockManager.shared
    private var timeTracker = TimeTracker()
    private let customBottomModalDelegate = CustomBottomModalDelegate()
    private let coreDataManager = CoreDataManager.shared
    
    
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
    
    
    
    // MARK: - Closure
    
    typealias Closure = (HomeViewController) -> ()
    var selectBlockEvent: Closure = { sender in }

    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        super.loadView()
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupCoreData()
        setupNavigation()
        setupDelegate()
        setupContentInset()
        setupGroupSelectButton()
        setupTimer()
        setupContentsBlock()
        setupTrackingButton()
        
//        // 테스트용 블럭 색칠
//        let color = blockManager.getCurrentGroupColor()
//        viewManager.blockPreview.block03.painting(.firstHalf, color: color)
//        viewManager.blockPreview.block17.painting(.secondHalf, color: color)
//        viewManager.blockPreview.block12.painting(.fullTime, color: color)
    }
    
    
    
    // MARK: - Setup Method
    
    func setupCoreData() {
        coreDataManager.fetchData()
    }
    
    func setupNavigation() {
        
        /// TrackingStopButton
        let trackingStopBarButtomItem = viewManager.trackingStopBarButtonItem
        navigationItem.rightBarButtonItem = trackingStopBarButtomItem
        
        /// 뒤로가기 버튼
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = GrayScale.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func setupDelegate() {
        
        /// HomeView
        viewManager.delegate = self
        
        /// blockCollectionView
        viewManager.blockCollectionView.dataSource = self
        viewManager.blockCollectionView.delegate = self
        viewManager.blockCollectionView.register(BlockCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: Cell.block)
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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(trackingBlockTapped))
        viewManager.trackingBlock.addGestureRecognizer(gesture)
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
        
        /// 00:00에 날짜 업데이트
        if viewManager.timeLabel.text == "00:00" { updateDate() }
    }
    
    /// 현재 날짜 및 요일 업데이트
    func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 E요일"
        viewManager.dateLabel.text = dateFormatter.string(from: Date())
    }
    
    @objc func trackingBlockTapped() {
        print(#function)
    }
}



// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockManager.getCurrentBlockList().count + 1 /// 블럭 추가 버튼 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewManager.blockCollectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.block, for: indexPath) as! BlockCollectionViewCell
        
        let index = indexPath.row
        let blockDataList = blockManager.getCurrentBlockList()
        
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
            cell.blockIcon.image = UIImage(systemName: blockDataList[index].icon)!
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
        
        let currentIndex = indexPath.item
        let count = blockManager.getCurrentBlockList().count
        
        /// 블럭 클릭 이벤트
        if blockIndex == currentIndex {
            
            // 셀 정보 바뀌어야 함 (reloadData?)
            selectBlockEvent(self)
            
            /// 마지막 블럭이라면 AddBlockViewController 화면 이동
            if count == currentIndex {
                viewManager.toggleTrackingButton(false)
                let createBlockVC = CreateBlockViewController()
                createBlockVC.delegate = self
                createBlockVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(createBlockVC, animated: true)
            }
        }
        
        /// 이전, 다음 블럭 스크롤 이벤트
        if blockIndex != currentIndex {
            viewManager.blockCollectionView.isUserInteractionEnabled = false /// 중복 터치 방지
            viewManager.blockCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            blockIndex = currentIndex
            
            /// 마지막 블럭이라면 Tracking 버튼 비활성화
            if count == currentIndex {
                viewManager.toggleTrackingButton(false)
            }
            
            /// 일반 블럭이라면 Tracking 버튼 활성화
            if count != currentIndex {
                viewManager.toggleTrackingButton(true)
            }
        }
    }
}



// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        /// 스크롤된 크기 = 스크롤이 멈춘 x좌표 + 스크롤뷰 inset
        let scrollSize = targetContentOffset.pointee.x + scrollView.contentInset.left
        
        /// 블럭 크기 = 블럭 가로 사이즈 + 블럭 여백 (보이는 영역 보다 크게 사이즈를 잡아야 캐러셀 구현 가능)
        let blockWidth = Size.blockSize.width + Size.blockSpacing
        
        /// 블럭 인덱스 = 스크롤된 크기 / 블럭 크기
        let currentBlockIndex = round(scrollSize / blockWidth)
        blockIndex = Int(currentBlockIndex)
        
        /// 최종 스크롤 위치 지정
        targetContentOffset.pointee = CGPoint(x: currentBlockIndex * blockWidth - scrollView.contentInset.left,
                                              y: scrollView.contentInset.top)
    }
    
    /// 스크롤 애니메이션 이후 다시 CollectionView 활성화
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        viewManager.blockCollectionView.isUserInteractionEnabled = true
    }
}



// MARK: - HomeViewDelegate

extension HomeViewController: HomeViewDelegate {
    
    func selectGroupButtonTapped() {
        let selectGroupVC = SelectGroupViewController()
        selectGroupVC.delegate = self
        selectGroupVC.modalPresentationStyle = .custom
        selectGroupVC.transitioningDelegate = customBottomModalDelegate
        present(selectGroupVC, animated: true)
    }
    
    func startTracking() {
        
        trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTrackingTime), userInfo: nil, repeats: true)
        
        /// 블럭 업데이트
        let blockDataList = blockManager.getCurrentBlockList()
        viewManager.trackingBlock.setupBlockContents(group: blockManager.getCurrentGroup(),
                                                     block: blockDataList[blockIndex])
        
        /// 화면 꺼짐 방지
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
        
        /// 화면 꺼짐 해제
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    /// 1초마다 실행되는 메서드
    @objc func updateTrackingTime() {
        timeTracker.totalTime += 1
        timeTracker.currentTime += 1
        
        /// 30분 단위 블럭 추가 및 현재 시간 초기화 (0.5블럭)
        if timeTracker.totalTime % 1800 == 0 {
            timeTracker.totalBlock += 0.5
            viewManager.updateCurrentProductivityLabel(timeTracker.totalBlock)
            timeTracker.currentTime = 0
        }
        
        /// TimeLabel & ProgressView 업데이트
        viewManager.updateTracking(time: timeTracker.timeFormatter,
                                   progress: timeTracker.currentTime / 1800)
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



// MARK: - CreateBlockViewControllerDelegate

extension HomeViewController: CreateBlockViewControllerDelegate {
    
    /// CollectionView 업데이트
    func updateCollectionView() {
        switchHomeGroup(index: blockManager.getCurrentGroupIndex())
        
        let lastIndex = blockManager.getLastBlockIndex()
        let indexPath = IndexPath(item: lastIndex, section: 0)
        blockIndex = lastIndex
        viewManager.blockCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        viewManager.toggleTrackingButton(true)
    }
}



// MARK: - SelectGroupViewControllerDelegate

extension HomeViewController: SelectGroupViewControllerDelegate {
    
    /// 그룹 업데이트
    func switchHomeGroup(index: Int) {
        blockManager.updateCurrentGroup(index: index)
        viewManager.groupSelectButton.color.backgroundColor = blockManager.getCurrentGroupColor()
        viewManager.groupSelectButton.label.text = blockManager.getCurrentGroup().name
        viewManager.blockCollectionView.reloadData()
        
        /// 스크롤 위치 초기화
        blockIndex = 0
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        
        /// 그룹 리스트가 비어있을 시, 트래킹 버튼 비활성화
        if blockManager.getCurrentGroup().list.isEmpty {
            viewManager.toggleTrackingButton(false)
        } else {
            viewManager.toggleTrackingButton(true)
        }
    }
}
