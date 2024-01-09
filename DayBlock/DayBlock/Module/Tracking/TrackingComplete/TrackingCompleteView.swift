//
//  TrackingCompleteView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/23.
//

import UIKit

final class TrackingCompleteView: UIView {
    
    // MARK: - Menu
    let backgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .none
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var menuBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = UIImage(systemName: "ellipsis")
        item.tintColor = Color.mainText
        return item
    }()
    
    lazy var finishBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "완료"
        item.style = .plain
        let font = UIFont(name: Pretendard.semiBold, size: 17)
        let attributes = [NSAttributedString.Key.font: font]
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .normal)
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .disabled)
        item.tintColor = Color.mainText
        return item
    }()
    
    lazy var saveBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "저장"
        item.style = .plain
        let font = UIFont(name: Pretendard.semiBold, size: 17)
        let attributes = [NSAttributedString.Key.font: font]
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .normal)
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .disabled)
        item.tintColor = Color.mainText
        return item
    }()
    
    let customMenu: Menu = {
        let menu = Menu(frame: .zero, number: .two)
        menu.firstItem.title.text = "메모 편집"
        menu.firstItem.icon.image = UIImage(systemName: "square.and.pencil")
        menu.secondItem.title.text = "트래킹 삭제"
        menu.secondItem.icon.image = UIImage(systemName: "trash")
        menu.alpha = 0
        return menu
    }()
    
    // MARK: - Properties
    
    let iconBlock: SimpleIconBlock = {
        let icon = SimpleIconBlock(size: 44)
        return icon
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 라벨"
        label.font = UIFont(name: Pretendard.semiBold, size: 15)
        label.textColor = UIColor(rgb: 0x616161)
        label.textAlignment = .center
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Swift 공부"
        label.font = UIFont(name: Pretendard.bold, size: 20)
        label.textColor = Color.mainText
        label.textAlignment = .center
        return label
    }()
    
    private let dashedSeparator = DashedSeparator(frame: .zero)
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년 09월 12일 화요일"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = UIColor(rgb: 0x8E8E8E)
        label.textAlignment = .center
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "14:05 ~ 15:35"
        label.font = UIFont(name: Poppins.bold, size: 30)
        label.textColor = Color.mainText
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Summary Label
    
    lazy var summaryLabel: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            leftSummaryLabel, plusSummaryLabel, mainSummaryLabel, rightSummaryLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    let leftSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "블럭"
        label.font = UIFont(name: Pretendard.bold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let plusSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = UIFont(name: Poppins.bold, size: 24)
        label.textColor = Color.defaultBlue
        label.textAlignment = .left
        return label
    }()
    
    let mainSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "2.5"
        label.font = UIFont(name: Poppins.bold, size: 24)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let rightSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "개를 생산했어요!"
        label.font = UIFont(name: Pretendard.bold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let trackingBoard: TrackingBoard = {
        let preview = TrackingBoard(frame: .zero, blockSize: 32, spacing: 8)
        return preview
    }()
    
    let memoPlaceHolder: UILabel = {
        let label = UILabel()
        label.text = "어떤 생산성을 발휘했는지 메모로 작성해봐요"
        label.textAlignment = .center
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = UIColor(rgb: 0xAAAAAA)
        return label
    }()
    
    let memoTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 24, bottom: 56, right: 24)
        textView.backgroundColor = Color.contentsBlock
        textView.font = UIFont(name: Pretendard.semiBold, size: 16)
        textView.textColor = UIColor(rgb: 0x616161)
        textView.textAlignment = .center
        return textView
    }()
    
    // MARK: - Animation Component
    
    let animationCircle: UIView = {
        let circle = UIView()
        circle.backgroundColor = Color.mainText
        circle.clipsToBounds = true
        return circle
    }()
    
    let checkSymbol: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 64, weight: .bold)
        let image = UIImageView()
        image.image = UIImage(systemName: "checkmark.square.fill")?.withConfiguration(configuration)
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        image.alpha = 0
        return image
    }()
    
    let checkLabel: UILabel = {
        let label = UILabel()
        label.text = "블럭 생산을 완료했어요!"
        label.font = UIFont(name: Pretendard.semiBold, size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    let memoEditCompleteToastView: ToastMessage = {
        let view = ToastMessage(state: .complete)
        view.messageLabel.text = "메모가 저장되었어요"
        view.alpha = 0
        return view
    }()
    
    // MARK: - Menu Method
    
    /// 메뉴 아이템을 토글합니다.
    func toggleMenu() {
        let alpha: CGFloat = customMenu.alpha == 1 ? 0 : 1
        UIView.animate(withDuration: 0.15) {
            self.customMenu.alpha = alpha
            self.backgroundView.alpha = alpha
        }
    }
    
    // MARK: - Placeholder Method
    
    /// TextView 상태에 따라 플레이스홀더를 업데이트합니다.
    func configurePlaceholder() {
        let alphaValue: CGFloat = memoTextView.text.isEmpty ? 1 : 0
        memoPlaceHolder.alpha = alphaValue
    }
    
    // MARK: - Animation Method
    
    /// 원 애니메이션을 시작합니다.
    func circleAnimation() {
        
        // cornerRadius
        animationCircle.layer.cornerRadius = animationCircle.frame.width / 2
        
        // Z-Index 조정
        animationCircle.layer.zPosition = -1
        
        // 커지는 애니메이션
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseInOut]) {
                
                self.animationCircle.transform = CGAffineTransform(scaleX: 1000, y: 1000)
                self.animationCircle.center = self.center
            } completion: { _ in
                self.checkAnimation()
            }
        }
    }
    
    /// 체크 애니메이션을 실행합니다.
    func checkAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            self.checkSymbol.alpha = 1
            self.checkLabel.alpha = 1
        } completion: { _ in
            
            func animationAfterSeconds() {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.animationEnd()
                }
            }
            
            // 심볼 이펙트 있는 버전
            if #available(iOS 17.0, *) { self.checkSymbol.addSymbolEffect(.bounce) { _ in animationAfterSeconds() }}
            
            // 심볼 이펙트 없는 버전
            else { animationAfterSeconds() }
        }
    }
    
    /// 블럭 생산 완료 애니메이션 종료 후 호출되는 메서드입니다.
    func animationEnd() {
        UIView.animate(withDuration: 0.3) {
            self.completeAnimation()
        }
    }
    
    func completeAnimation() {
        
        // 비활성화
        [animationCircle, checkSymbol, checkLabel].forEach { $0.alpha = 0 }
        
        // 활성화
        [
            iconBlock,
            groupLabel,
            taskLabel,
            dashedSeparator,
            dateLabel,
            timeLabel,
            summaryLabel,
            trackingBoard,
            memoTextView
        ].forEach { $0.alpha = 1 }
        
        configurePlaceholder()
        finishBarButtonItem.customView?.alpha = 1
    }
    
    // MARK: - Initial Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupAddView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var topConstraint: NSLayoutConstraint!
    
    // MARK: - Auto Layout Method
    
    private func setupAddView() {
        [backgroundView,
         iconBlock, groupLabel, taskLabel,
         dashedSeparator,
         dateLabel, timeLabel,
         summaryLabel,
         trackingBoard,
         memoTextView, memoPlaceHolder,
         customMenu, memoEditCompleteToastView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.alpha = 0
        }
        
        [animationCircle, checkSymbol, checkLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            // backgroundView
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // customMenu
            customMenu.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -8),
            customMenu.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            // iconBlock
            iconBlock.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            iconBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // groupLabel
            groupLabel.topAnchor.constraint(equalTo: iconBlock.bottomAnchor, constant: 16),
            groupLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // taskLabel
            taskLabel.topAnchor.constraint(equalTo: groupLabel.bottomAnchor, constant: 2),
            taskLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // dashedSeparator
            dashedSeparator.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 32),
            dashedSeparator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 86),
            dashedSeparator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -86),
            
            // dateLabel
            dateLabel.topAnchor.constraint(equalTo: dashedSeparator.bottomAnchor, constant: 32),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // timeLabel
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0),
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // summaryLabel
            summaryLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 32),
            summaryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // trackingBoard
            trackingBoard.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 8),
            trackingBoard.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // memoPlaceHolder
            memoPlaceHolder.topAnchor.constraint(equalTo: memoTextView.topAnchor, constant: 24),
            memoPlaceHolder.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // memoTextField
            memoTextView.topAnchor.constraint(equalTo: trackingBoard.bottomAnchor, constant: 56),
            memoTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // animationCircle
            animationCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationCircle.widthAnchor.constraint(equalToConstant: 1),
            animationCircle.heightAnchor.constraint(equalToConstant: 1),
            
            // checkSymbol
            checkSymbol.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkSymbol.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
            checkSymbol.widthAnchor.constraint(equalToConstant: 64),
            checkSymbol.heightAnchor.constraint(equalToConstant: 64),
            
            // checkLabel
            checkLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkLabel.topAnchor.constraint(equalTo: checkSymbol.bottomAnchor, constant: 20),
            
            // memoEditCompleteToastView
            memoEditCompleteToastView.centerXAnchor.constraint(equalTo: centerXAnchor),
            memoEditCompleteToastView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48)
        ])
    }
}
