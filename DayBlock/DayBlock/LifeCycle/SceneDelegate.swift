//
//  SceneDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    /// 앱에서 나간 시간 저장용
    var timestamp: Date?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // Code Base 설정
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // 첫 실행인지 확인
        if UserDefaultsItem.shared.isFirstLaunch {
            window?.rootViewController = StartViewController()
        } else {
            changeRootViewControllerToHome()
        }
        
        window?.makeKeyAndVisible()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
        // 마지막 접속 시간 Notification 전달
        NotificationCenter.default.post(
            name: .latestAccess,
            object: nil,
            userInfo: ["time" : UserDefaultsItem.shared.lastAccessSecond])
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        // 1. 타이머 정지
        TimerManager.shared.trackingTimer?.invalidate()
        TimerManager.shared.pausedTimer?.invalidate()
        
        // 2. 코어데이터 저장
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        // 3. 나가는 시점 저장
        let lastAccessSecond = TrackingDataStore.shared.todaySecondsToInt()
        UserDefaultsItem.shared.setLastAccessSecond(to: lastAccessSecond)
        
        // 테스트: 나가는 시점의 Date 저장
        let lastAccessDate = Date()
        UserDefaultsItem.shared.setLastAccessDate(to: lastAccessDate)
        
        // 4. trackingSecond 저장
        let trackingSecond = TimerManager.shared.totalTrackingSecond
        UserDefaultsItem.shared.setTrackingSecondBeforeAppTermination(to: trackingSecond)
        
        // 5. 일시정지 시간 저장
        let pausedSecond = TimerManager.shared.pausedTime
        UserDefaultsItem.shared.setPausedSecond(to: pausedSecond)
        
        // 6. 트래킹 시간 배열 저장
        let trackingSeconds = TrackingBoardService.shared.trackingSeconds
        UserDefaultsItem.shared.setTrackingSeconds(to: trackingSeconds)
    }
    
    // MARK: - Change Root View
    
    /// HomeViewController로 루트뷰를 변경합니다.
    func changeRootViewControllerToHome() {
        guard let window = self.window else { return }
        
        // UINavigation 추가
        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
        let calendarNavigationController = UINavigationController(rootViewController: RepositoryViewController())
        let manageBlockViewController = UINavigationController(rootViewController: ManageBlockViewController())
        let myPageViewController = UINavigationController(rootViewController: MyPageViewController())
        
        // UITabBarController 추가
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        tabBarController.tabBar.tintColor = Color.mainText
        tabBarController.setViewControllers([
            homeNavigationController,
            calendarNavigationController,
            manageBlockViewController,
            myPageViewController
        ], animated: true)
        
        // UITabBarItem 추가
        if let items = tabBarController.tabBar.items {
            
            // homeNavigationController
            items[0].image = UIImage(named: Icon.home)
            items[0].title = "트래킹"
            
            // calendarNavigationController
            items[1].image = UIImage(named: Icon.schedule)
            items[1].title = "캘린더"
            
            // manageBlockViewController
            items[2].image = UIImage(named: Icon.storage)
            items[2].title = "관리소"
            
            // myPageViewController
            items[3].image = UIImage(named: Icon.myPage)
            items[3].title = "내정보"
            
            for index in items.indices {
                let font = UIFont(name: Pretendard.semiBold,size: 15)!
                items[index].setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            }
        }
        
        window.rootViewController = tabBarController
        
        // 부드러운 전환을 위한 효과 추가
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}

// MARK: - UITabBarControllerDelegate
extension SceneDelegate: UITabBarControllerDelegate {
    
    /// 탭 바가 선택됐을 때 호출되는 메서드입니다.
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Vibration.light.vibrate()
    }
}
