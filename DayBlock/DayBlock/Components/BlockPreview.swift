//
//  BlockPreview.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/01.
//

import UIKit

final class BlockPreview: UIView {
    
    // MARK: - Blocks
    
    private let block00: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block01: UIView = {
        let view = UIView()
        return view
    }()

    
    private let block02: UIView = {
        let view = UIView()
        return view
    }()

    private let block03: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block04: UIView = {
        let view = UIView()
        return view
    }()

    
    private let block05: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block06: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block07: UIView = {
        let view = UIView()
        return view
    }()

    
    private let block08: UIView = {
        let view = UIView()
        return view
    }()

    private let block09: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block10: UIView = {
        let view = UIView()
        return view
    }()

    
    private let block11: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block12: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block13: UIView = {
        let view = UIView()
        return view
    }()

    
    private let block14: UIView = {
        let view = UIView()
        return view
    }()

    private let block15: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block16: UIView = {
        let view = UIView()
        return view
    }()

    
    private let block17: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block18: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block19: UIView = {
        let view = UIView()
        return view
    }()

    
    private let block20: UIView = {
        let view = UIView()
        return view
    }()

    private let block21: UIView = {
        let view = UIView()
        return view
    }()
    
    private let block22: UIView = {
        let view = UIView()
        return view
    }()

    
    private let block23: UIView = {
        let view = UIView()
        return view
    }()
    
    
    // MARK: - Constatns
    private let blockSize: CGFloat = 18
    private let spacing: CGFloat = 4
    
    
    // MARK: - Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitial()
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        /// 전체 블럭 공통 설정
        [
            block00, block01, block02, block03, block04, block05,
            block06, block07, block08, block09, block10, block11,
            block12, block13, block14, block15, block16, block17,
            block18, block19, block20, block21, block22, block23,
        ]
            .forEach {
                
                /// Block Background Color
                $0.backgroundColor = GrayScale.entireBlock
                
                /// Block Size
                $0.widthAnchor.constraint(equalToConstant: blockSize).isActive = true
                $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
                
                /// Block CornerRadius
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 6
            }    }
    
    func setupInitial() {
        // backgroundColor = GrayScale.entireBlock
    }
    
    func setupAddSubView() {
        
        [
            block00, block01, block02, block03, block04, block05,
            block06, block07, block08, block09, block10, block11,
            block12, block13, block14, block15, block16, block17,
            block18, block19, block20, block21, block22, block23,
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
            
            /// block00
            block00.topAnchor.constraint(equalTo: topAnchor),
            block00.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            /// block01
            block01.topAnchor.constraint(equalTo: topAnchor),
            block01.leadingAnchor.constraint(equalTo: block00.trailingAnchor, constant: spacing),
            
            /// block02
            block02.topAnchor.constraint(equalTo: topAnchor),
            block02.leadingAnchor.constraint(equalTo: block01.trailingAnchor, constant: spacing),
            
            /// block03
            block03.topAnchor.constraint(equalTo: topAnchor),
            block03.leadingAnchor.constraint(equalTo: block02.trailingAnchor, constant: spacing),
            
            /// block04
            block04.topAnchor.constraint(equalTo: topAnchor),
            block04.leadingAnchor.constraint(equalTo: block03.trailingAnchor, constant: spacing),
            
            /// block05
            block05.topAnchor.constraint(equalTo: topAnchor),
            block05.leadingAnchor.constraint(equalTo: block04.trailingAnchor, constant: spacing),
            
            /// block06
            block06.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block06.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            /// block07
            block07.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block07.leadingAnchor.constraint(equalTo: block06.trailingAnchor, constant: spacing),
            
            /// block08
            block08.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block08.leadingAnchor.constraint(equalTo: block07.trailingAnchor, constant: spacing),
            
            /// block09
            block09.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block09.leadingAnchor.constraint(equalTo: block08.trailingAnchor, constant: spacing),
            
            /// block10
            block10.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block10.leadingAnchor.constraint(equalTo: block09.trailingAnchor, constant: spacing),
            
            /// block11
            block11.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block11.leadingAnchor.constraint(equalTo: block10.trailingAnchor, constant: spacing),
            
            /// block12
            block12.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block12.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            /// block13
            block13.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block13.leadingAnchor.constraint(equalTo: block12.trailingAnchor, constant: spacing),
            
            /// block14
            block14.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block14.leadingAnchor.constraint(equalTo: block13.trailingAnchor, constant: spacing),
            
            /// block15
            block15.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block15.leadingAnchor.constraint(equalTo: block14.trailingAnchor, constant: spacing),
            
            /// block16
            block16.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block16.leadingAnchor.constraint(equalTo: block15.trailingAnchor, constant: spacing),
            
            /// block17
            block17.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block17.leadingAnchor.constraint(equalTo: block16.trailingAnchor, constant: spacing),
            
            /// block18
            block18.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block18.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            /// block19
            block19.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block19.leadingAnchor.constraint(equalTo: block18.trailingAnchor, constant: spacing),
            
            /// block20
            block20.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block20.leadingAnchor.constraint(equalTo: block19.trailingAnchor, constant: spacing),
            
            /// block21
            block21.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block21.leadingAnchor.constraint(equalTo: block20.trailingAnchor, constant: spacing),
            
            /// block22
            block22.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block22.leadingAnchor.constraint(equalTo: block21.trailingAnchor, constant: spacing),
            
            /// block23
            block23.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block23.leadingAnchor.constraint(equalTo: block22.trailingAnchor, constant: spacing),
        ])
    }
    
}
