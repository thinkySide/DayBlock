//
//  IconManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/05/09.
//

import UIKit

/// 아이콘(SFSymbol) 관리 매니저
final class IconManager {

    /// 싱글톤 패턴
    static let shared = IconManager()
    private init() {
        // icons = symbols
        icons = [objectSymbols, natureSymbols, fitnessSymbols, furnitureSymbols, etcSymbols]
    }

    /// 현재 아이콘의 인덱스 값
    private var index = 0

    /// 아이콘 리스트
    private var icons: [[String]]
    
    /// 현재 사용 중인 리스트
    private lazy var currents: [String] = alllist()

    // MARK: - Method
    
    /// 현재 사용 중인 아이콘 리스트를 반환합니다.
    func currentList() -> [String] {
        return currents
    }
    
    /// 현재 선택된 아이콘을 리턴합니다.
    func selected() -> String {
        return alllist()[index]
    }

    /// 현재 선택된 아이콘의 인덱스를 리턴합니다.
    func selectedIndex() -> Int {
        
        var selectedIndex = 0
        
        // 1. 전체 기호 리스트일 경우 그대로 저장
        if currents == alllist() {
            selectedIndex = index
        }
        
        // 2. 사물 기호 리스트일 경우
        else if currents == objectlist() {
            selectedIndex = index
        }
        
        // 3. 자연 기호 리스트일 경우
        else if currents == natureList() {
            selectedIndex = index - objectlist().count
        }
        
        // 4. 운동 기호 리스트일 경우
        else if currents == fitnessList() {
            selectedIndex = index - objectlist().count - natureList().count
        }
        
        // 5. 가구 기호 리스트일 경우
        else if currents == furnitureList() {
            selectedIndex = index - objectlist().count - natureList().count - fitnessList().count
        }
        
        // 6. 기타 기호 리스트일 경우
        else if currents == etcList() {
            selectedIndex = index - objectlist().count - natureList().count - fitnessList().count - furnitureList().count
        }
        
        print("선택 인덱스: \(selectedIndex)")
        return selectedIndex
    }
    
    // MARK: - Get Icon List

    /// 아이콘 전체 리스트를 리턴합니다.
    func alllist() -> [String] {
        return icons.flatMap { $0 }
    }
    
    /// 사물 아이콘  리스트를 리턴합니다.
    func objectlist() -> [String] {
        return icons[0]
    }
    
    /// 자연 아이콘 리스트를 반환합니다.
    func natureList() -> [String] {
        return icons[1]
    }
    
    /// 자연 아이콘 리스트를 반환합니다.
    func fitnessList() -> [String] {
        return icons[2]
    }
    
    /// 자연 아이콘 리스트를 반환합니다.
    func furnitureList() -> [String] {
        return icons[3]
    }
    
    /// 기타 아이콘 리스트를 반환합니다.
    func etcList() -> [String] {
        return icons[4]
    }
    
    // MARK: - Update CurrentList
    
    /// 사용 중인 리스트를 전체 리스트로 업데이트합니다.
    func updateCurrentListToAll() {
        currents = alllist()
    }
    
    /// 사용 중인 리스트를 사물 리스트로 업데이트합니다.
    func updateCurrentListToObject() {
        currents = objectlist()
    }
    
    /// 사용 중인 리스트를 자연 리스트로 업데이트합니다.
    func updateCurrentListToNature() {
        currents = natureList()
    }
    
    /// 사용 중인 리스트를 운동 리스트로 업데이트합니다.
    func updateCurrentListToFintess() {
        currents = fitnessList()
    }
    
    /// 사용 중인 리스트를 가구 리스트로 업데이트합니다.
    func updateCurrentListToFurniture() {
        currents = furnitureList()
    }
    
    /// 사용 중인 리스트를 기타 리스트로 업데이트합니다.
    func updateCurrentListToTraffic() {
        currents = etcList()
    }
    
    // MARK: - Index Upate

    /// 현재 선택된 아이콘의 인덱스를 업데이트합니다.
    ///
    /// - Parameter index: 업데이트 할 인덱스
    func updateSelectedIndex(to index: Int) {
        
        // 1. 전체 기호 리스트일 경우 그대로 저장
        if currents == alllist() {
            self.index = index
        }
        
        // 2. 사물 기호 리스트일 경우
        else if currents == objectlist() {
            self.index = index
        }
        
        // 3. 자연 기호 리스트일 경우
        else if currents == natureList() {
            self.index = objectlist().count + index
        }
        
        // 4. 운동 기호 리스트일 경우
        else if currents == fitnessList() {
            self.index = objectlist().count + natureList().count + index
        }
        
        // 5. 가구 기호 리스트일 경우
        else if currents == furnitureList() {
            self.index = objectlist().count + natureList().count + fitnessList().count + index
        }
        
        // 6. 기타 기호 리스트일 경우
        else if currents == etcList() {
            self.index = objectlist().count + natureList().count + fitnessList().count + furnitureList().count + index
        }
    }

    /// 현재 선택된 아이콘의 인덱스를 현재 아이콘을 기준으로 업데이트합니다.
    ///
    /// - Parameter currentIcon: 현재 아이콘 문자열
    func updateSelectedIndex(as currentIcon: String) {
        for (index, icon) in (alllist().enumerated()) where currentIcon == icon {
            self.index = index
        }
    }
}
