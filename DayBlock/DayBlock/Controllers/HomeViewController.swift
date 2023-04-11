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
    private let blockManager = BlockManager()
    private var timeTracker = TimeTracker()
    
    
    // MARK: - Component
    
    private var dateTimer: Timer!
    private var trackingTimer: Timer!
    private let groupSelectButton = GroupSelectButton()
    
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        super.loadView()
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTimer()
        setupDelegate()
        setupContentInset()
        
        // 테스트용 블럭 색칠
        viewManager.blockPreview.block03.painting(.firstHalf)
        viewManager.blockPreview.block17.painting(.secondHalf)
        viewManager.blockPreview.block12.painting(.fullTime)
    }

    
    
    // MARK: - Method
    
    func setupNavigation() {
        /// 뒤로가기 버튼
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = GrayScale.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
        
        /// 그룹 선택 버튼
        let gesture = UITapGestureRecognizer(target: self, action: #selector(groupSelectButtonTapped))
        groupSelectButton.addGestureRecognizer(gesture)
        navigationItem.titleView = groupSelectButton
    }
    
    func setupTimer() {
        updateDate()
        updateTime()
        
        /// 날짜 및 시간 업데이트용 타이머 설정
        dateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
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
    
    /// 현재 시간 업데이트
    @objc func updateTime() {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "HH:mm"
        viewManager.timeLabel.text = timeFormatter.string(from: Date())
        
        /// 00:00에 날짜 업데이트
        if viewManager.timeLabel.text == "00:00" { updateDate() }
    }
    
    @objc func groupSelectButtonTapped() {
        print(#function)
    }
    
    /// 현재 날짜 및 요일 업데이트
    func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 E요일"
        viewManager.dateLabel.text = dateFormatter.string(from: Date())
    }
    
    /// 시간 Tracking
    
}



// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockManager.getBlockList("자기계발").list.count + 1 /// 블럭 추가 버튼 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewManager.blockCollectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.block, for: indexPath) as! BlockCollectionViewCell
        
        let index = indexPath.row
        let blockDataList = blockManager.getBlockList("자기계발").list
        
        /// 일반 블럭 생성
        if index+1 <= blockDataList.count {
            cell.plusLabel.textColor = blockDataList[index].color
            cell.totalProductivityLabel.text = "\(blockDataList[index].output)"
            cell.blockColorTag.backgroundColor = blockDataList[index].color
            cell.blockIcon.image = blockDataList[index].icon
            cell.blockLabel.text = blockDataList[index].label
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
        let count = blockManager.getBlockList("자기계발").list.count
        if count == indexPath.row {
            
            /// Push to AddBlockViewController
            let addBlockVC = AddBlockViewController()
            addBlockVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(addBlockVC, animated: true)
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
        let blockIndex = round(scrollSize / blockWidth)
        
        /// 최종 스크롤 위치 지정
        targetContentOffset.pointee = CGPoint(x: blockIndex * blockWidth - scrollView.contentInset.left,
                                              y: scrollView.contentInset.top)
    }
    
}



// MARK: - HomeViewDelegate

extension HomeViewController: HomeViewDelegate {
    func startTracking() {
        trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTrackingTime), userInfo: nil, repeats: true)
    }
    
    func stopTracking() {
        trackingTimer.invalidate()
        timeTracker.totalTime = 0
    }
    
    @objc func updateTrackingTime() {
        timeTracker.totalTime += 1
        timeTracker.currentTime += 1
        
        /// 30분 단위로 현재 시간 초기화 (0.5블럭)
        if timeTracker.totalTime == 1800 { timeTracker.currentTime = 0 }
        
        /// TimeLabel & ProgressView 업데이트
        viewManager.updateTracking(time: timeTracker.timeFormatter,
                                   progress: timeTracker.currentTime / 1800)
    }
    
    func hideTabBar() {
        viewManager.tabBarStackView.alpha = viewManager.tabBarStackView.alpha == 1 ? 0 : 1
        tabBarController?.tabBar.alpha = tabBarController?.tabBar.alpha == 1 ? 0 : 1
    }
}
