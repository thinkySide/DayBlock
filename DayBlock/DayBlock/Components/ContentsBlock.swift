//
//  ContentsBlock.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/08.
//

import UIKit

protocol ContentsBlockDelegate: AnyObject {
    func storeTrackingBlock()
}

final class ContentsBlock: UIView {
    
    // MARK: - Size
    
    /// 블럭 사이즈
    enum Size {
        case middle
        case large
    }
    
    /// 사이즈 지정용 변수
    var size: Size
    
    /// 애니메이션 Completion 관리용 클로저
    var storeTrackingBlockClosure: (() -> Void)?
    
    /// ContentsBlockDelegate
    weak var delegate: ContentsBlockDelegate?
    
    
    // MARK: - Component

    private lazy var contentsView: UIView = {
        let view = UIView()
        // view.backgroundColor = GrayScale.contentsBlock
        view.clipsToBounds = true
        [fillLayerBlock, plus, currentProductivityLabel, colorTag, icon, taskLabel]
            .forEach { view.addSubview($0) }
        return view
    }()
    
    /// 블럭 애니메이션 용 레이어
    let fillLayerBlock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xF4F5F7)
        return view
    }()
    
    let plus: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()
    
    var currentProductivityLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        return label
    }()
    
    private let colorTag: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.clipsToBounds = true
        
        /// 하단 왼쪽, 하단 오른쪽만 cornerRadius 값 주기
        view.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        return view
    }()
    
    private let icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "batteryblock.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = GrayScale.mainText
        return image
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Github 브랜치 관리하기"
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    
    // MARK: - Variable
    private let middleSize = CGSize(width: 180, height: 180)
    private let largeSize = CGSize(width: 250, height: 250)
    
    
    
    // MARK: - View Method
    
    init(frame: CGRect, blockSize: Size) {
        self.size = blockSize
        super.init(frame: frame)
        setupBlockSize()
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        /// CornerRaius
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 7
    }
    
    
    // MARK: - Custom Method
    
    func setupBlockContents(group: GroupEntity, block: BlockEntity) {
        plus.textColor = UIColor(rgb: group.color)
        colorTag.backgroundColor = UIColor(rgb: group.color)
        icon.image = UIImage(systemName: block.icon)!
        taskLabel.text = block.taskLabel
        contentsView.backgroundColor = UIColor(rgb: group.color).withAlphaComponent(0.2)
    }
    
    /// 트래킹 블럭 저장 클로저 할당 및 델리게이트 실행
    func setupStoreTrackingBlock() {
        storeTrackingBlockClosure = {
            self.delegate?.storeTrackingBlock()
        }
    }
    
    /// 블럭 Long Press Gesture Animation
    func animation(isFill: Bool) {
        
        // 칠하는 애니메이션
        if isFill {
            
            // 트래킹 블럭 저장 클로저 할당
            setupStoreTrackingBlock()
            
            UIView.animate(withDuration: 0.9, delay: 0.15, usingSpringWithDamping: 1, initialSpringVelocity: 0.1) {
                self.fillLayerBlock.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
            } completion: { _ in
                if let storeClosure = self.storeTrackingBlockClosure {
                    storeClosure()
                    return
                }
            }
        }

        if !isFill {
            // CompletionHandler가 실행되면 안되기 때문에 nil 할당
            storeTrackingBlockClosure = nil
            
            UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1) {
                self.fillLayerBlock.transform = CGAffineTransform(translationX: 0, y: 0)
            } completion: { _ in
                // 애니메이션 지우기 끝
            }
        }
    }

    func setupBlockSize() {
        /// BlockSize
        switch size {
        case .middle:
            self.widthAnchor.constraint(equalToConstant: middleSize.width).isActive = true
            self.heightAnchor.constraint(equalToConstant: middleSize.height).isActive = true
            
            /// 디자인 설정
            plus.font = UIFont(name: Poppins.bold, size: 18)
            plus.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16).isActive = true
            plus.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16).isActive = true
            
            currentProductivityLabel.font = UIFont(name: Poppins.bold, size: 18)
            currentProductivityLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16).isActive = true
            
            colorTag.layer.cornerRadius = 9
            colorTag.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -32).isActive = true
            colorTag.widthAnchor.constraint(equalToConstant: 20).isActive = true
            colorTag.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            icon.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 48).isActive = true
            icon.widthAnchor.constraint(equalToConstant: 56).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 56).isActive = true
            
            taskLabel.font = UIFont(name: Pretendard.bold, size: 17)
            
        case .large:
            self.widthAnchor.constraint(equalToConstant: largeSize.width).isActive = true
            self.heightAnchor.constraint(equalToConstant: largeSize.height).isActive = true
            
            /// 디자인 설정
            plus.font = UIFont(name: Poppins.bold, size: 24)
            plus.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 24).isActive = true
            plus.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 24).isActive = true
            
            currentProductivityLabel.font = UIFont(name: Poppins.bold, size: 24)
            currentProductivityLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 24).isActive = true
            
            colorTag.layer.cornerRadius = 11
            colorTag.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -48).isActive = true
            colorTag.widthAnchor.constraint(equalToConstant: 26).isActive = true
            colorTag.heightAnchor.constraint(equalToConstant: 38).isActive = true
            
            icon.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 68).isActive = true
            icon.widthAnchor.constraint(equalToConstant: 88).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            taskLabel.font = UIFont(name: Pretendard.bold, size: 24)
        }
    }
    
    
    // MARK: - AutoLayout Method
    
    func setupAddSubView() {
        // 1. addSubView(component)
        [contentsView]
            .forEach { addSubview($0) }
        
        // 2. translatesAutoresizingMaskIntoConstraints = false
        [contentsView, fillLayerBlock,
         plus, currentProductivityLabel, colorTag, icon, taskLabel]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    func setupConstraints() {
        // 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            // contentsView
            contentsView.topAnchor.constraint(equalTo: topAnchor),
            contentsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // fillLayerBlock
            fillLayerBlock.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            fillLayerBlock.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor),
            // 스프링 애니메이션으로 인한 오른쪽 튀어나옴 방지
            fillLayerBlock.widthAnchor.constraint(equalTo: contentsView.widthAnchor, constant: 240),
            fillLayerBlock.heightAnchor.constraint(equalTo: contentsView.heightAnchor),
            
            // totalProductivityLabel
            currentProductivityLabel.leadingAnchor.constraint(equalTo: plus.trailingAnchor),
            
            // colorTag
            colorTag.topAnchor.constraint(equalTo: contentsView.topAnchor),
            
            // icon
            icon.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            
            // taskLabel
            taskLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
            taskLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 24),
            taskLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -24),
        ])
    }
}


