//
//  TrackingDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 10/1/23.
//

import Foundation

@objc protocol TrackingCompleteViewControllerDelegate: AnyObject {
    @objc optional func trackingCompleteVC(backToHomeButtonTapped trackingCompleteVC: TrackingCompleteViewController)
    @objc optional func trackingCompleteVC(didTrackingDataRemoved trackingCompleteVC: TrackingCompleteViewController)
}
