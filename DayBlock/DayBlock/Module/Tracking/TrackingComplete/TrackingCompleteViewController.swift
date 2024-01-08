//
//  TrackingCompleteViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/23.
//

import UIKit

final class TrackingCompleteViewController: UIViewController {
    
    enum Mode {
        case tracking
        case onboarding
        case calendar
    }
    
    var mode: Mode
    var item: RepositoryItem?
    weak var delegate: TrackingCompleteViewControllerDelegate?
    
    private let viewManager = TrackingCompleteView()
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    private let trackingData = TrackingDataStore.shared
    
    // MARK: - Life Cycle Methods
    
    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        setupKeyboard()
        
        // 캘린더 모드라면 바로 정보 표시
        if mode == .calendar {
            viewManager.completeAnimation()
            return
        }
        
        // 애니메이션 출력
        DispatchQueue.main.async {
            self.viewManager.circleAnimation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TrackingBoardService.shared.resetAllData()
        view.endEditing(true)
    }
    
    // MARK: - Setup Method
    
    private func setupUI() {
        
        // 캘린더 모드라면 해당 UI 업데이트 사용 X
        if mode == .calendar { return }
        
        // 네비게이션 아이템 설정
        navigationItem.rightBarButtonItem = viewManager.finishBarButtonItem
        
        // 애니메이션 컬러
        viewManager.animationCircle.backgroundColor = groupData.focusColor()
        
        // 아이콘
        viewManager.iconBlock.backgroundColor = groupData.focusColor()
        viewManager.iconBlock.symbol.image = UIImage(systemName: blockData.focusEntity().icon)
        
        // 그룹명
        viewManager.groupLabel.text = groupData.focusEntity().name
        
        // 작업명
        viewManager.taskLabel.text = blockData.focusEntity().taskLabel
        
        // 날짜 및 시간 라벨
        viewManager.dateLabel.text = trackingData.focusDateFormat()
        viewManager.timeLabel.text = trackingData.focusTrackingTimeFormat()
        
        // 생산량 라벨
        viewManager.plusSummaryLabel.textColor = groupData.focusColor()
        viewManager.mainSummaryLabel.text = String(trackingData.focusTrackingBlockCount())
        
        // 트래킹 보드: 트래킹 모드
        if mode == .tracking {
            let block = BlockDataStore.shared.focusEntity()
            
            // 트래킹 보드 업데이트
            let timeList = trackingData.focusDate().trackingTimeList?.array as! [TrackingTime]
            for time in timeList {
                TrackingBoardService.shared.appendTrackingSecond(to: Int(time.startTime)!)
            }
            
            let trackingTimes = TrackingBoardService.shared.trackingSeconds
            TrackingBoardService.shared.updateTrackingBoard(to: trackingData.focusDateToDate(), block: block, trackingTimes: trackingTimes)
            TrackingBoardService.shared.stopAllAnimation()
            viewManager.trackingBoard.updateBoard()
        }
        
        // 트래킹 보드: 온보딩 모드
        else if mode == .onboarding {
            
            // 만약 30분 전이 어제라면
            if TrackingDataStore.shared.todaySecondsToInt() < 1800 {
                TrackingBoardService.shared.updateTrackingBoard(to: Date().previousDay(from: Date()))
            } else {
                TrackingBoardService.shared.updateTrackingBoard(to: Date())
            }
            viewManager.trackingBoard.updateBoard()
        }
    }
    
    /// 캘린더 모드에서의 UI를 설정합니다.
    func setupCalendarMode(item: RepositoryItem, currentDate: String, trackingTime: String, output: String) {
        
        // 아이템 저장
        self.item = item
        
        // 네비게이션 아이템 추가
        navigationItem.rightBarButtonItem = viewManager.menuBarButtonItem
        
        // 아이콘
        viewManager.iconBlock.backgroundColor = item.groupColor.uicolor
        viewManager.iconBlock.symbol.image = UIImage(systemName: item.blockIcon)
        
        // 그룹 라벨
        viewManager.groupLabel.text = item.groupName
        
        // 작업명
        viewManager.taskLabel.text = item.blockTaskLabel
        
        // 날짜 및 시간 라벨
        viewManager.dateLabel.text = currentDate
        viewManager.timeLabel.text = trackingTime
        
        // 생산량 라벨
        viewManager.plusSummaryLabel.textColor = item.groupColor.uicolor
        viewManager.mainSummaryLabel.text = output
        
        // 트래킹 보드
        let trackingTimes = item.trackingTimes.map { Int($0.startTime)! }
        let block = BlockDataStore.shared.listInSelectedGroupInBlock(groupName: item.groupName, blockName: item.blockTaskLabel)
        let currentDate = RepositoryManager.shared.currentDate
        TrackingBoardService.shared.updateTrackingBoard(to: currentDate, block: block, trackingTimes: trackingTimes)
        TrackingBoardService.shared.stopAllAnimation()
        viewManager.trackingBoard.updateBoard()
        
        // 메모
        let memoTextView = viewManager.memoTextView
        if !memoTextView.text.isEmpty { viewManager.memoPlaceHolder.alpha = 0 }
        memoTextView.isEditable = false
        memoTextView.text = item.memo
    }
    
    private func setupEvent() {
        let menuBackgroundGesture = UITapGestureRecognizer(target: self, action: #selector(menuBackgroundTapped))
        viewManager.backgroundView.addGestureRecognizer(menuBackgroundGesture)
        
        viewManager.menuBarButtonItem.target = self
        viewManager.menuBarButtonItem.action = #selector(menuBarButtonItemTapped)
        
        viewManager.finishBarButtonItem.target = self
        viewManager.finishBarButtonItem.action = #selector(finishBarButtonItemTapped)
        
        viewManager.saveBarButtonItem.target = self
        viewManager.saveBarButtonItem.action = #selector(saveBarButtonItemTapped)
        
        let editMemoGesture = UITapGestureRecognizer(target: self, action: #selector(editMemoItemTapped))
        viewManager.customMenu.firstItem.addGestureRecognizer(editMemoGesture)
        
        let deleteTrackingGesture = UITapGestureRecognizer(target: self, action: #selector(deleteTrackingItemTapped))
        viewManager.customMenu.secondItem.addGestureRecognizer(deleteTrackingGesture)
    }
    
    private func setupKeyboard() {
        addHideKeyboardGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    // MARK: - Event Method
    
    /// 메뉴 배경을 탭 했을 때 호출되는 메서드입니다.
    @objc func menuBackgroundTapped() {
        viewManager.toggleMenu()
    }
    
    /// 메뉴 BarButtonItem을 탭 했을 때 호출되는 메서드입니다.
    @objc func menuBarButtonItemTapped() {
        viewManager.toggleMenu()
    }
    
    /// 트래킹 완료 BarButtonItem을 탭 했을 때 호출되는 메서드입니다.
    @objc func finishBarButtonItemTapped() {
        
        // 키보드 내리기
        view.endEditing(true)
        
        // 메모 코어데이터 저장
        trackingData.focusDate().memo = viewManager.memoTextView.text
        GroupDataStore.shared.saveContext()
        
        // 트래킹 모드
        if mode == .tracking {
            delegate?.trackingCompleteVC!(backToHomeButtonTapped: self)
            dismiss(animated: true)
            return
        }
        
        // 온보딩 모드
        else if mode == .onboarding {
            dismiss(animated: true)
            
            // 루트 뷰 컨트롤러 변경
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.changeRootViewControllerToHome()
            return
        }
    }
    
    /// 메모 저장 BarButtonItem을 탭 했을 때 호출되는 메서드입니다.
    @objc func saveBarButtonItemTapped() {
        
        // 키보드 내리기
        view.endEditing(true)
        
        // TextView 편집 불가 설정
        viewManager.memoTextView.isEditable = false
        
        // 메뉴 아이템 변경
        navigationItem.rightBarButtonItem = viewManager.menuBarButtonItem
        
        // 코어데이터 저장
        
    }
    
    /// 메모 편집 메뉴 아이템을 탭 했을 때 호출되는 메서드입니다.
    @objc func editMemoItemTapped() {
        
        // 메뉴 닫기
        viewManager.toggleMenu()
        
        // 텍스트뷰 메모 편집 허용
        viewManager.memoTextView.isEditable = true
        
        // 키보드 올라오기
        viewManager.memoTextView.becomeFirstResponder()
        
        // 바 버튼 아이템 변경
        navigationItem.rightBarButtonItem = viewManager.saveBarButtonItem
    }
    
    /// 트래킹 삭제 메뉴 아이템을 탭 했을 때 호출되는 메서드입니다.
    @objc func deleteTrackingItemTapped() {
        
        // 메뉴 닫기
        viewManager.toggleMenu()
        
        // 팝업 출력
        let deletePopup = PopupViewController()
        deletePopup.delegate = self
        deletePopup.modalPresentationStyle = .overCurrentContext
        deletePopup.modalTransitionStyle = .crossDissolve
        
        let popupView = deletePopup.deletePopupView
        popupView.mainLabel.text = "트래킹 데이터를 삭제할까요?"
        popupView.subLabel.text = "선택한 기간의 데이터가 삭제돼요"
        popupView.actionStackView.confirmButton.setTitle("삭제할래요", for: .normal)
        
        self.present(deletePopup, animated: true)
    }
}

// MARK: - Keyboard
extension TrackingCompleteViewController {

    /// 키보드가 숨겨질 때 호출되는 메서드입니다.
    @objc func keyboardWillHide(_ sender: Notification) {
        viewManager.configurePlaceholder()
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    /// 키보드가 변경될 때 호출되는 메서드입니다.
    @objc func keyboardWillChange(_ sender: Notification) {
        
        // 키보드 프레임
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // 키보드값 초기화
        view.frame.origin.y = 0
        
        // 키보드값 다시 돌리기
        let keyboardHeight = keyboardFrame.cgRectValue.height
        view.frame.origin.y -= keyboardHeight
        
        // Placeholder 가리기
        viewManager.memoPlaceHolder.alpha = 0
    }
}

// MARK: - PopupViewControllerDelegate
extension TrackingCompleteViewController: PopupViewControllerDelegate {
    
    /// 삭제할래요 팝업 버튼 탭 시 호출되는 메서드입니다.
    func confirmButtonTapped() {
        
        // 트래킹 데이터 삭제
        guard let item = self.item else { return }
        trackingData.removeTrackingDate(to: item)
        
        // 데이터 리로드를 위한 Delegate 호출
        delegate?.trackingCompleteVC!(didTrackingDataRemoved: self)
        
        // 이전 화면으로 이동
        navigationController?.popViewController(animated: true)
    }
}
