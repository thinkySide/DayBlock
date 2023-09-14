//
//  BlockDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/14.
//

import Foundation

protocol CreateBlockViewControllerDelegate: AnyObject {
    func reloadCollectionView()
    func updateCollectionView(_ isEditMode: Bool)
}
