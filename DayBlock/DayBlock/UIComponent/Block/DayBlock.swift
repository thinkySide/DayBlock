//
//  DayBlock.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/08.
//

import UIKit

/// 트래킹 화면의 메인 블럭 컴포넌트
final class DayBlock: UIView {
    
    /// ContentsBlockDelegate
    weak var delegate: DayBlockDelegate?
    
    /// 블럭 사이즈
    enum Size: Double {
        case middle = 180
        case large = 250
    }
    
    /// 사이즈 지정용 변수
    private var size: Size
    
    /// 애니메이션 Completion 관리용 클로저
    private var storeTrackingBlockClosure: (() -> Void)?
    
    // MARK: - Component
    
    /// 컴포넌트가 올라갈 View
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        [animationView, plus, outputLabel, colorTag, icon, taskLabel]
            .forEach { view.addSubview($0) }
        return view
    }()
    
    /// 애니메이션용 View
    let animationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xF4F5F7)
        return view
    }()
    
    /// 플러스 기호
    let plus: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()
    
    /// 생산성 합계 라벨
    let outputLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    /// 컬러 태그
    let colorTag: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.clipsToBounds = true
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        return view
    }()
    
    /// 아이콘
    let icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "batteryblock.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = Color.mainText
        return image
    }()
    
    /// 작업명 라벨
    let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Github 브랜치 관리하기"
        label.textColor = Color.mainText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Event Method
    
    /// 블럭 UI를 업데이트합니다.
    ///
    /// - Parameter group: 업데이트 할 그룹 정보
    /// - Parameter block: 업데이트 할 블럭 정보
    func update(group: Group, block: Block) {
        plus.textColor = UIColor(rgb: group.color)
        colorTag.backgroundColor = UIColor(rgb: group.color)
        icon.image = UIImage(systemName: block.icon)!
        taskLabel.text = block.taskLabel
        contentsView.backgroundColor = UIColor(rgb: group.color).withAlphaComponent(0.2)
    }
    
    /// 생산성 라벨값을 업데이트합니다.
    ///
    /// - Parameter value: 업데이트할 생산성 합계값
    func updateProductivityLabel(to value: Double) {
        outputLabel.text = String(value)
    }
    
    /// LongPressGesture 애니메이션 실행 메서드입니다.
    ///
    /// - Parameter isFill: 애니메이션이 칠해져있는 상태인지 여부
    func longPressAnimation(isFill: Bool) {
        
        // 칠하는 애니메이션
        if isFill {
            
            Vibration.light.vibrate()
            
            // 트래킹 블럭 저장 클로저 할당
            storeTrackingBlockClosure = { [weak self] in
                guard let self else { return }
                delegate?.dayBlock(self, trackingComplete: taskLabel.text)
            }
            
            UIView.animate(withDuration: 0.9, delay: 0.15, usingSpringWithDamping: 1, initialSpringVelocity: 0.1) {
                self.animationView.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
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
                self.animationView.transform = CGAffineTransform(translationX: 0, y: 0)
            } completion: { _ in
                // 애니메이션 지우기 끝
            }
        }
    }

    /// 초기에 설정된 크기에 맞게 블럭 사이즈를 설정합니다.
    func setupBlockSize() {
        if size == .middle {
            plus.font = UIFont(name: Poppins.bold, size: 18)
            outputLabel.font = UIFont(name: Poppins.bold, size: 18)
            colorTag.layer.cornerRadius = 9
            taskLabel.font = UIFont(name: Pretendard.bold, size: 17)

            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: Size.middle.rawValue),
                self.heightAnchor.constraint(equalToConstant: Size.middle.rawValue),
                plus.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
                plus.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
                outputLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
                colorTag.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -32),
                colorTag.widthAnchor.constraint(equalToConstant: 20),
                colorTag.heightAnchor.constraint(equalToConstant: 30),
                icon.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 52),
                icon.widthAnchor.constraint(equalToConstant: 64),
                icon.heightAnchor.constraint(equalToConstant: 64),
                taskLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16)
            ])
        }

        if size == .large {
            plus.font = UIFont(name: Poppins.bold, size: 24)
            outputLabel.font = UIFont(name: Poppins.bold, size: 24)
            colorTag.layer.cornerRadius = 11
            taskLabel.font = UIFont(name: Pretendard.bold, size: 24)

            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: Size.large.rawValue),
                self.heightAnchor.constraint(equalToConstant: Size.large.rawValue),
                plus.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 24),
                plus.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 24),
                outputLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 24),
                colorTag.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -48),
                colorTag.widthAnchor.constraint(equalToConstant: 26),
                colorTag.heightAnchor.constraint(equalToConstant: 38),
                icon.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 68),
                icon.widthAnchor.constraint(equalToConstant: 88),
                icon.heightAnchor.constraint(equalToConstant: 88),
                taskLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 24)
            ])
        }
    }
    
    // MARK: - Initial Method
    
    init(frame: CGRect, blockSize: Size) {
        self.size = blockSize
        super.init(frame: frame)
        setupBlockSize()
        setupAutoLayout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clipsToBounds = true
        layer.cornerRadius = frame.height / 7
    }

    /// AutoLayout 설정 메서드입니다.
    private func setupAutoLayout() {
        [contentsView]
            .forEach { addSubview($0) }
    
        [contentsView, animationView,
         plus, outputLabel, colorTag, icon, taskLabel]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
        
            contentsView.topAnchor.constraint(equalTo: topAnchor),
            contentsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: trailingAnchor),
        
            // 스프링 애니메이션으로 인한 오른쪽 튀어나옴 방지
            animationView.widthAnchor.constraint(equalTo: contentsView.widthAnchor, constant: 240),
            animationView.heightAnchor.constraint(equalTo: contentsView.heightAnchor),
            animationView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            animationView.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor),
            
            outputLabel.leadingAnchor.constraint(equalTo: plus.trailingAnchor),
            
            colorTag.topAnchor.constraint(equalTo: contentsView.topAnchor),
            
            icon.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            
            taskLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 24),
            taskLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
