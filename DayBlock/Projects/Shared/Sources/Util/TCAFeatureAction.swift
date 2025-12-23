//
//  TCAFeatureAction.swift
//  Util
//
//  Created by 김민준 on 12/23/25.
//

import Foundation

public protocol TCAFeatureAction {
    associatedtype ViewAction
    associatedtype InnerAction
    associatedtype DelegateAction
    
    static func view(_: ViewAction) -> Self
    static func inner(_: InnerAction) -> Self
    static func delegate(_: DelegateAction) -> Self
}
