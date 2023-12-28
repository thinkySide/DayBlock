//
//  HomeView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeView: UIView {
    
    enum TrakingMode {
        case start
        case pause
        case restart
        case stop
        case finish
    }
    
    weak var delegate: HomeViewDelegate?
    var trackingMode: TrakingMode = .finish
    
    // MARK: - Component
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.subText
        label.textAlignment = .center
        label.numberOfLines = 4
        return label
    }()
    
    let groupSelectButton: GroupSelectButton = {
        let group = GroupSelectButton()
        return group
    }()
    
    lazy var trackingStopBarButtonItem: UIBarButtonItem = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setImage(UIImage(named: Icon.trackingStop), for: .normal)
        button.tintColor = Color.contentsBlock
        let item = UIBarButtonItem(customView: button)
        item.customView?.isHidden = true
        return item
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.subText
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 56)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let productivityLabel: UILabel = {
        let label = UILabel()
        label.text = "today +0.0" // ⛳️
        label.font = UIFont(name: Poppins.bold, size: 23)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    /// 트래킹용 블럭 프리뷰
    let trackingBoard: TrackingBoard = {
        let preview = TrackingBoard(frame: .zero, blockSize: 18, spacing: 4)
        return preview
    }()
    
    lazy var blockCollectionView: UICollectionView = {
        
        /// layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Size.blockSize
        layout.minimumLineSpacing = Size.blockSpacing
        layout.minimumInteritemSpacing = 0
        
        /// collectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    let trackingBlock: DayBlock = {
        let block = DayBlock(frame: .zero, blockSize: .large)
        block.isHidden = true
        return block
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 15)
        label.textColor = Color.subText2
        label.numberOfLines = 2
        label.asLineSpacing(targetString: "오늘 하루는 어떤 블럭으로\n채우고 계신가요?", lineSpacing: 4, alignment: .center)
        return label
    }()
    
    private let trackingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = UIFont(name: Poppins.bold, size: 36)
        label.textColor = Color.mainText
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let trackingProgressView: UIProgressView = {
        let progress = UIProgressView()
        progress.trackTintColor = Color.contentsBlock
        progress.progress = 0
        progress.isHidden = true
        return progress
    }()
    
    private lazy var trackingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Icon.trackingStart), for: .normal)
        button.addTarget(self, action: #selector(trackingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let warningToastView: ToastMessage = {
        let view = ToastMessage(state: .warning)
        view.messageLabel.text = "블럭 0.5개 이상 생산 시 등록이 가능해요"
        view.alpha = 0
        return view
    }()
    
    let infoToastView: ToastMessage = {
        let view = ToastMessage(state: .complete)
        view.messageLabel.text = "하루가 지나 새로운 트래킹 세션이 시작되었어요"
        view.alpha = 0
        return view
    }()
    
    let tabBarStackView = TabBar(location: .tracking)
    
    // MARK: - Method
    
    /// 트래킹 모드를 중단합니다.
    func stopTrackingMode() {
        trackingMode = .stop
        delegate?.homeView(self, trackingDidStop: trackingMode)
        
        // Tracking 버튼 설정
        trackingButton.setImage(UIImage(named: Icon.trackingStart), for: .normal)
        
        // 공통 설정
        delegate?.homeView(self, displayTabBarForTrackingMode: true)
        groupSelectButton.isHidden = false
        blockCollectionView.isHidden = false
        trackingBlock.isHidden = true
        messageLabel.isHidden = false
        trackingTimeLabel.isHidden = true
        trackingProgressView.isHidden = true
        trackingStopBarButtonItem.customView?.isHidden = true
    }
    
    /// 트래킹 완료 후 종료합니다.
    func finishTrackingMode() {
        
        // Tracking 종료
        trackingMode = .finish
        delegate?.homeView(self, trackingDidFinish: trackingMode)
        
        // Tracking 버튼 설정
        trackingButton.setImage(UIImage(named: Icon.trackingStart), for: .normal)
        
        // 공통 설정
        delegate?.homeView(self, displayTabBarForTrackingMode: true)
        groupSelectButton.isHidden = false
        blockCollectionView.isHidden = false
        trackingBlock.isHidden = true
        messageLabel.isHidden = false
        trackingTimeLabel.isHidden = true
        trackingProgressView.isHidden = true
        trackingStopBarButtonItem.customView?.isHidden = true
    }
    
    @objc func trackingButtonTapped() {
        
        trackingButton.isUserInteractionEnabled = false
        Vibration.selection.vibrate()
        
        // 트래킹 모드 변경 로직
        if trackingMode == .finish || trackingMode == .stop { trackingMode = .start }
        else if trackingMode == .start { trackingMode = .pause }
        else if trackingMode == .pause { trackingMode = .restart }
        else if trackingMode == .restart { trackingMode = .pause }
        
        // Tracking 모드 설정
        switch trackingMode {
        case .start:
            delegate?.homeView(self, trackingDidStart: trackingMode)
            trackingTimeLabel.textColor = Color.mainText
            trackingButton.setImage(UIImage(named: Icon.trackingPause), for: .normal)
            delegate?.homeView(self, setupProgressViewColor: .start)
            
        case .pause:
            delegate?.homeView(self, trackingDidPause: trackingMode)
            trackingTimeLabel.textColor = Color.disabledText
            trackingButton.setImage(UIImage(named: Icon.trackingStart), for: .normal)
            trackingProgressView.progressTintColor = Color.disabledText
            
        case .restart:
            delegate?.homeView(self, trackingDidRestart: trackingMode)
            trackingTimeLabel.textColor = Color.mainText
            trackingButton.setImage(UIImage(named: Icon.trackingPause), for: .normal)
            delegate?.homeView(self, setupProgressViewColor: .start)
            
        case .stop: break
            
        case .finish: break
        }
        
        // 공통 설정
        delegate?.homeView(self, displayTabBarForTrackingMode: false)
        groupSelectButton.isHidden = true
        blockCollectionView.isHidden = true
        trackingBlock.isHidden = false
        messageLabel.isHidden = true
        trackingTimeLabel.isHidden = false
        trackingProgressView.isHidden = false
        trackingStopBarButtonItem.customView?.isHidden = false
        trackingButton.isUserInteractionEnabled = true
    }
    
    /// 앱이 다시 실행됐을 때 작동하는 메서드
    func trackingRestartForDisconnect() {
        
        // 트래킹 모드 변경 로직
        if trackingMode == .finish || trackingMode == .stop { trackingMode = .start }
        else if trackingMode == .start { trackingMode = .pause }
        else if trackingMode == .pause { trackingMode = .restart }
        else if trackingMode == .restart { trackingMode = .pause }
        
        print("현재 트래킹 모드: \(trackingMode)")
        
        // Tracking 모드 설정
        switch trackingMode {
        case .start:
            delegate?.homeView(self, trackingDidRelaunch: trackingMode)
            trackingTimeLabel.textColor = Color.mainText
            trackingButton.setImage(UIImage(named: Icon.trackingPause), for: .normal)
            delegate?.homeView(self, setupProgressViewColor: .start)
            
        case .pause:
            delegate?.homeView(self, trackingDidPause: trackingMode)
            trackingTimeLabel.textColor = Color.disabledText
            trackingButton.setImage(UIImage(named: Icon.trackingStart), for: .normal)
            trackingProgressView.progressTintColor = Color.disabledText
            
        case .restart:
            delegate?.homeView(self, trackingDidRestart: trackingMode)
            trackingTimeLabel.textColor = Color.mainText
            trackingButton.setImage(UIImage(named: Icon.trackingPause), for: .normal)
            delegate?.homeView(self, setupProgressViewColor: .start)
            
        case .stop:
            break
            
        case .finish:
            break
        }
        
        // 공통 설정
        delegate?.homeView(self, displayTabBarForTrackingMode: false)
        groupSelectButton.isHidden = true
        blockCollectionView.isHidden = true
        trackingBlock.isHidden = false
        messageLabel.isHidden = true
        trackingTimeLabel.isHidden = false
        trackingProgressView.isHidden = false
        trackingStopBarButtonItem.customView?.isHidden = false
    }
    
    func toggleTrackingButton(_ bool: Bool) {
        if bool { trackingButton.isEnabled = true }
        else { trackingButton.isEnabled = false }
    }
    
    func setupProgressViewColor(color: UIColor) {
        trackingProgressView.progressTintColor = color
    }
    
    func updateTracking(time: String, progress: Float) {
        trackingTimeLabel.text = time
        trackingProgressView.setProgress(progress, animated: true)
    }
    
    func updateCurrentOutputLabel(_ amount: Double) {
        trackingBlock.updateProductivityLabel(to: amount)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitial()
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitial() {
        backgroundColor = .white
    }
    
    func setupAddSubView() {
        [
            groupSelectButton,
            dateLabel, timeLabel, productivityLabel,
            trackingBoard,
            blockCollectionView,
            trackingBlock,
            messageLabel,
            trackingTimeLabel,
            trackingProgressView,
            trackingButton,
            warningToastView,
            infoToastView,
            tabBarStackView,
            testLabel
        ]
            .forEach {
                /// 1. addSubView(component)
                addSubview($0)
                
                /// 2. translatesAutoresizingMaskIntoConstraints = false
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    func setupConstraints() {
        
        /// 3. isActive = true
        NSLayoutConstraint.activate([
            
            /// dateLabel
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin+2), /// 시각 보정
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
            
            /// timeLabel
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin-2), // 시각 보정
            timeLabel.heightAnchor.constraint(equalToConstant: timeLabel.font.pointSize),
            
            /// productivityLabel
            productivityLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 3),
            productivityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin+2), /// 시각 보정
            productivityLabel.heightAnchor.constraint(equalToConstant: 24),
            
            /// groupSelectButton
            groupSelectButton.topAnchor.constraint(equalTo: productivityLabel.bottomAnchor, constant: 24),
            groupSelectButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// outputBlockPreview
            trackingBoard.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            trackingBoard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            trackingBoard.widthAnchor.constraint(equalToConstant: 128),
            trackingBoard.heightAnchor.constraint(equalToConstant: 84),
            
            /// blockCollectionView
            blockCollectionView.topAnchor.constraint(equalTo: groupSelectButton.bottomAnchor, constant: 12),
            blockCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blockCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blockCollectionView.heightAnchor.constraint(equalToConstant: Size.blockSize.height),
            
            /// trackingBlock
            trackingBlock.topAnchor.constraint(equalTo: productivityLabel.bottomAnchor, constant: 32),
            trackingBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// messageLabel
            messageLabel.topAnchor.constraint(equalTo: blockCollectionView.bottomAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: trackingButton.topAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// trackingTimeLabel
            trackingTimeLabel.topAnchor.constraint(equalTo: trackingBlock.bottomAnchor),
            trackingTimeLabel.bottomAnchor.constraint(equalTo: trackingButton.topAnchor),
            trackingTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// trackingProgressView
            trackingProgressView.centerYAnchor.constraint(equalTo: trackingButton.centerYAnchor),
            trackingProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -4),
            trackingProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4),
            trackingProgressView.heightAnchor.constraint(equalToConstant: 10),
            
            /// trackingButton
            trackingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -48),
            trackingButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            trackingButton.widthAnchor.constraint(equalToConstant: 64),
            trackingButton.heightAnchor.constraint(equalToConstant: 64),
            
            warningToastView.centerXAnchor.constraint(equalTo: centerXAnchor),
            warningToastView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
            
            infoToastView.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoToastView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
            
            testLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            testLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -68),
            
            /// tabBarStackView
            tabBarStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
