//
//  StartView.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class StartView: UIView {
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [image, startButton])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: StartImage.startImage)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let startButton: ActionButton = {
        let button = ActionButton(frame: .zero, mode: .confirm)
        button.setTitle("시작하기", for: .normal)
        button.layer.cornerRadius = 28
        return button
    }()
    
    // MARK: - Initial Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [vStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            vStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            startButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
