//
//  SettingVC+EmailContact.swift
//  DayBlock
//
//  Created by 김민준 on 12/14/23.
//

import UIKit
import MessageUI

extension MyPageViewController: MFMailComposeViewControllerDelegate {
    
    /// 이메일 문의 셀 버튼 탭 시 호출되는 메서드입니다.
    func emailContactCellTapped() {
        
        let contactEmail = "eunlyuing@gmail.com"
        
        if MFMailComposeViewController.canSendMail() {
            let emailVC = MFMailComposeViewController()
            emailVC.mailComposeDelegate = self
            emailVC.setToRecipients([contactEmail])
            emailVC.setSubject("[DayBlock] 이메일 문의")
            
            let mailBody = """
            문의 내용을 작성해주세요.
            
            --------------------
            
            Device / \(UIDevice.current.model) \(UIDevice.current.systemVersion)
            APP Version / \(Version.current)
            
            --------------------
            """
            
            emailVC.setMessageBody(mailBody, isHTML: false)
            present(emailVC, animated: true)
        } 
        
        // 메일 앱 연동 되어있지 않을 시
        else {
            
            // 이메일 주소 클립보드 복사하기
            UIPasteboard.general.string = contactEmail
            
            showToast(toast: viewManager.invalidMailToastView, isActive: true)
            Vibration.error.vibrate()
        }
    }
    
    /// 메일 전송 분기 처리를 위한 Delegate 메서드입니다.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
            
        case .cancelled:
            dismiss(animated: true)
            
        case .saved:
            dismiss(animated: true)
            
        case .sent:
            dismiss(animated: true)
            showToast(toast: viewManager.successMailToastView, isActive: true)
            Vibration.success.vibrate()
            
        case .failed:
            dismiss(animated: true)
            showToast(toast: viewManager.failMailToastView, isActive: true)
            Vibration.error.vibrate()
            
        @unknown default: break
        }
    }
}
