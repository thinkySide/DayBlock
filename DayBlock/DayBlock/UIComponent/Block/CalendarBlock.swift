//
//  CalendarBlock.swift
//  DayBlock
//
//  Created by 김민준 on 12/6/23.
//

import UIKit

/// 캘린더 셀 상태 열거형
enum CalendarCellState {
    case none
    case one
    case two
    case three
    case four
    case five
    
}

final class CalendarBlock: UIView {
    
    let oneBlock = OneBlock(size: 24)
    let twoBlock = TwoBlock(size: 24)
    let threeBlock = ThreeBlock(size: 24)
    let fourBlock = FourBlock(size: 24)
    let fiveBlock = FiveBlock(size: 24)
    
    init(state: CalendarCellState, colors: [UIColor] = [
        Color.defaultBlue, Color.defaultPink, Color.defaultGreen, Color.defaultYellow, .systemPurple
    ]) {
        super.init(frame: .zero)
        setupAutoLayout()
        updateState(state, colors: colors)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 셀의 상태를 업데이트합니다.
    func updateState(_ state: CalendarCellState, colors: [UIColor]) {
        switch state {
        case .none:
            oneBlock.alpha = 1
            twoBlock.alpha = 0
            threeBlock.alpha = 0
            fourBlock.alpha = 0
            fiveBlock.alpha = 0
            oneBlock.block.backgroundColor = Color.entireBlock
            
        case .one:
            oneBlock.alpha = 1
            twoBlock.alpha = 0
            threeBlock.alpha = 0
            fourBlock.alpha = 0
            fiveBlock.alpha = 0
            oneBlock.block.backgroundColor = colors[0]
            
        case .two:
            oneBlock.alpha = 0
            twoBlock.alpha = 1
            threeBlock.alpha = 0
            fourBlock.alpha = 0
            fiveBlock.alpha = 0
            twoBlock.firstBlock.backgroundColor = colors[0]
            twoBlock.secondBlock.backgroundColor = colors[1]
            
        case .three:
            oneBlock.alpha = 0
            twoBlock.alpha = 0
            threeBlock.alpha = 1
            fourBlock.alpha = 0
            fiveBlock.alpha = 0
            threeBlock.firstBlock.backgroundColor = colors[0]
            threeBlock.secondBlock.backgroundColor = colors[1]
            threeBlock.thirdBlock.backgroundColor = colors[2]
            
        case .four:
            oneBlock.alpha = 0
            twoBlock.alpha = 0
            threeBlock.alpha = 0
            fourBlock.alpha = 1
            fiveBlock.alpha = 0
            fourBlock.firstBlock.backgroundColor = colors[0]
            fourBlock.secondBlock.backgroundColor = colors[1]
            fourBlock.thirdBlock.backgroundColor = colors[2]
            fourBlock.fourthBlock.backgroundColor = colors[3]
            
        case .five:
            oneBlock.alpha = 0
            twoBlock.alpha = 0
            threeBlock.alpha = 0
            fourBlock.alpha = 0
            fiveBlock.alpha = 1
            fiveBlock.firstBlock.backgroundColor = colors[0]
            fiveBlock.secondBlock.backgroundColor = colors[1]
            fiveBlock.thirdBlock.backgroundColor = colors[2]
            fiveBlock.fourthBlock.backgroundColor = colors[3]
            fiveBlock.fifthBlock.backgroundColor = colors[4]
        }
    }
    
    private func setupAutoLayout() {
        [oneBlock, twoBlock, threeBlock, fourBlock, fiveBlock].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            oneBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            oneBlock.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            twoBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            twoBlock.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            threeBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            threeBlock.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            fourBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            fourBlock.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            fiveBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            fiveBlock.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - 없음 & 한개짜리
    final class OneBlock: UIView {
        let block: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultBlue
            view.clipsToBounds = true
            view.layer.cornerRadius = 7
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        init(size: CGFloat) {
            super.init(frame: .zero)
            self.backgroundColor = .white
            
            addSubview(block)
            
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: size),
                self.heightAnchor.constraint(equalToConstant: size),
                block.topAnchor.constraint(equalTo: topAnchor),
                block.bottomAnchor.constraint(equalTo: bottomAnchor),
                block.leadingAnchor.constraint(equalTo: leadingAnchor),
                block.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: - 두개짜리
    final class TwoBlock: UIView {
        
        let firstBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultBlue
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let secondBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultPink
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        init(size: CGFloat) {
            super.init(frame: .zero)
            self.backgroundColor = .white
            
            addSubview(firstBlock)
            addSubview(secondBlock)
            
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: size),
                self.heightAnchor.constraint(equalToConstant: size),
                
                firstBlock.topAnchor.constraint(equalTo: topAnchor),
                firstBlock.leadingAnchor.constraint(equalTo: leadingAnchor),
                firstBlock.trailingAnchor.constraint(equalTo: trailingAnchor),
                firstBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                secondBlock.bottomAnchor.constraint(equalTo: bottomAnchor),
                secondBlock.leadingAnchor.constraint(equalTo: leadingAnchor),
                secondBlock.trailingAnchor.constraint(equalTo: trailingAnchor),
                secondBlock.heightAnchor.constraint(equalToConstant: size / 2)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: - 세개짜리
    final class ThreeBlock: UIView {
        
        let firstBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultBlue
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let secondBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultPink
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let thirdBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultGreen
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        init(size: CGFloat) {
            super.init(frame: .zero)
            self.backgroundColor = .white
            
            addSubview(firstBlock)
            addSubview(secondBlock)
            addSubview(thirdBlock)
            
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: size),
                self.heightAnchor.constraint(equalToConstant: size),
                
                firstBlock.topAnchor.constraint(equalTo: topAnchor),
                firstBlock.leadingAnchor.constraint(equalTo: leadingAnchor),
                firstBlock.trailingAnchor.constraint(equalTo: trailingAnchor),
                firstBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                secondBlock.bottomAnchor.constraint(equalTo: bottomAnchor),
                secondBlock.leadingAnchor.constraint(equalTo: leadingAnchor),
                secondBlock.widthAnchor.constraint(equalToConstant: size / 2),
                secondBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                thirdBlock.bottomAnchor.constraint(equalTo: bottomAnchor),
                thirdBlock.trailingAnchor.constraint(equalTo: trailingAnchor),
                thirdBlock.widthAnchor.constraint(equalToConstant: size / 2),
                thirdBlock.heightAnchor.constraint(equalToConstant: size / 2)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: - 네개짜리
    final class FourBlock: UIView {
        
        let firstBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultBlue
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let secondBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultPink
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let thirdBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultGreen
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let fourthBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultYellow
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        init(size: CGFloat) {
            super.init(frame: .zero)
            self.backgroundColor = .white
            
            addSubview(firstBlock)
            addSubview(secondBlock)
            addSubview(thirdBlock)
            addSubview(fourthBlock)
            
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: size),
                self.heightAnchor.constraint(equalToConstant: size),
                
                firstBlock.topAnchor.constraint(equalTo: topAnchor),
                firstBlock.leadingAnchor.constraint(equalTo: leadingAnchor),
                firstBlock.widthAnchor.constraint(equalToConstant: size / 2),
                firstBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                secondBlock.topAnchor.constraint(equalTo: topAnchor),
                secondBlock.trailingAnchor.constraint(equalTo: trailingAnchor),
                secondBlock.widthAnchor.constraint(equalToConstant: size / 2),
                secondBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                thirdBlock.bottomAnchor.constraint(equalTo: bottomAnchor),
                thirdBlock.leadingAnchor.constraint(equalTo: leadingAnchor),
                thirdBlock.widthAnchor.constraint(equalToConstant: size / 2),
                thirdBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                fourthBlock.bottomAnchor.constraint(equalTo: bottomAnchor),
                fourthBlock.trailingAnchor.constraint(equalTo: trailingAnchor),
                fourthBlock.widthAnchor.constraint(equalToConstant: size / 2),
                fourthBlock.heightAnchor.constraint(equalToConstant: size / 2)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: - 다섯개짜리
    final class FiveBlock: UIView {
        
        let firstBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultBlue
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let secondBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultPink
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let thirdBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultGreen
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let fourthBlock: UIView = {
            let view = UIView()
            view.backgroundColor = Color.defaultYellow
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let fifthBlock: UIView = {
            let view = UIView()
            view.backgroundColor = .systemPurple
            view.clipsToBounds = true
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        init(size: CGFloat) {
            super.init(frame: .zero)
            self.backgroundColor = .white
            
            addSubview(firstBlock)
            addSubview(secondBlock)
            addSubview(thirdBlock)
            addSubview(fourthBlock)
            addSubview(fifthBlock)
            
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: size),
                self.heightAnchor.constraint(equalToConstant: size),
                
                firstBlock.topAnchor.constraint(equalTo: topAnchor),
                firstBlock.leadingAnchor.constraint(equalTo: leadingAnchor),
                firstBlock.widthAnchor.constraint(equalToConstant: size / 2),
                firstBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                secondBlock.topAnchor.constraint(equalTo: topAnchor),
                secondBlock.trailingAnchor.constraint(equalTo: trailingAnchor),
                secondBlock.widthAnchor.constraint(equalToConstant: size / 2),
                secondBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                thirdBlock.bottomAnchor.constraint(equalTo: bottomAnchor),
                thirdBlock.leadingAnchor.constraint(equalTo: leadingAnchor),
                thirdBlock.widthAnchor.constraint(equalToConstant: size / 2),
                thirdBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                fourthBlock.bottomAnchor.constraint(equalTo: bottomAnchor),
                fourthBlock.trailingAnchor.constraint(equalTo: trailingAnchor),
                fourthBlock.widthAnchor.constraint(equalToConstant: size / 2),
                fourthBlock.heightAnchor.constraint(equalToConstant: size / 2),
                
                fifthBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
                fifthBlock.centerYAnchor.constraint(equalTo: centerYAnchor),
                fifthBlock.widthAnchor.constraint(equalToConstant: size / 2),
                fifthBlock.heightAnchor.constraint(equalToConstant: size / 2)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
