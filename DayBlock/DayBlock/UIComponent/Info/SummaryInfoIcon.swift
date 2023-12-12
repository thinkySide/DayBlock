//
//  SummaryInfoIcon.swift
//  DayBlock
//
//  Created by 김민준 on 12/12/23.
//

import UIKit

final class SummaryInfoIcon: UIView {
    
    let circle: UIView = {
        let circle = UIView()
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 12
        circle.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        return circle
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "batteryblock.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.semiBold, size: 16)
        label.textColor = UIColor(rgb: 0x545454)
        label.textAlignment = .center
        label.text = "72.5"
        return label
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.semiBold, size: 13)
        label.textColor = UIColor(rgb: 0xB0B0B0)
        label.textAlignment = .center
        label.text = "total"
        return label
    }()
    
    func updateColor(_ color: UIColor) {
        icon.tintColor = color
        circle.backgroundColor = color.withAlphaComponent(0.2)
    }
    
    // MARK: - Initial Method
    init() {
        super.init(frame: .zero)
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [circle, icon, valueLabel, tagLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: circle.topAnchor),
            self.bottomAnchor.constraint(equalTo: tagLabel.bottomAnchor),
            self.widthAnchor.constraint(equalToConstant: 102),
            
            circle.topAnchor.constraint(equalTo: topAnchor),
            circle.centerXAnchor.constraint(equalTo: centerXAnchor),
            circle.widthAnchor.constraint(equalToConstant: 24),
            circle.heightAnchor.constraint(equalToConstant: 24),
            
            icon.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 14),
            icon.heightAnchor.constraint(equalToConstant: 14),
            
            valueLabel.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 4),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tagLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: -2),
            tagLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
