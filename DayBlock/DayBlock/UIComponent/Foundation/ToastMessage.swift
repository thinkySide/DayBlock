//
//  ToastMessage.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/18.
//

import UIKit

/// 토스트 메시지 컴포넌트
final class ToastMessage: UIView {

    /// 토스트 메시지 좌측 아이콘
    let icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tintColor = UIColor(rgb: 0xF6C05A)
        image.image = UIImage(systemName: "exclamationmark.circle.fill")
        return image
    }()

    /// 토스트 메시지 아이콘 우측 메시지 라벨
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "토스트 메시지를 작성하세요."
        label.font = UIFont(name: Pretendard.semiBold, size: 17)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    // MARK: - Initial Method

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
    }

    /// 컴포넌트 기본 UI 설정 메서드입니다.
    private func setupUI() {
        backgroundColor = UIColor(rgb: 0x67696A)
        clipsToBounds = true
        layer.cornerRadius = 13
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// AutoLayout 설정 메서드입니다.
    private func setupAutoLayout() {
        [icon, messageLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16),
            self.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),

            icon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),

            messageLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
