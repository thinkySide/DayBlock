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
        
        // UINavigation 추가
        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
        let scheduleNavigationController = UINavigationController(rootViewController: ManageViewController())
        let storageNavigationController = UINavigationController(rootViewController: RepositoryViewController())
        
        // UITabBarController 추가
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = Color.mainText
        tabBarController.setViewControllers([
            homeNavigationController,
            scheduleNavigationController,
            storageNavigationController
        ], animated: true)
        
        // UITabBarItem 추가
        if let items = tabBarController.tabBar.items {
            
            // homeNavigationController
            items[0].image = UIImage(named: Icon.home)
            items[0].title = "트래킹"
            
            // scheduleNavigationController
            items[1].image = UIImage(named: Icon.schedule)
            items[1].title = "관리소"
            
            // storageNavigationController
            items[2].image = UIImage(named: Icon.storage)
            items[2].title = "저장소"
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
        // 마지막 접속 시간 Notification 전달
        if let latestAccess = UserDefaults.standard.object(forKey: UserDefaultsKey.latestAccess) as? Int {
            NotificationCenter.default.post(
                name: NSNotification.Name(Noti.latestAccess),
                object: nil,
                userInfo: ["time" : latestAccess])
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        // 1. 타이머 정지
        TimerManager.shared.trackingTimer?.invalidate()
        
        // 2. 코어데이터 저장
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        // 3. 나가는 시점 저장
        let lastAccess = Int(TrackingDataStore.shared.todaySecondsToString())
        UserDefaults.standard.setValue(lastAccess, forKey: UserDefaultsKey.latestAccess)
        
        // 4. totalTime 저장
        let totalTime = TimerManager.shared.totalTime
        UserDefaults.standard.setValue(totalTime, forKey: UserDefaultsKey.totalTime)
        
        // 5. 일시정지 시간 저장
        let pausedTime = TimerManager.shared.pausedTime
        UserDefaults.standard.setValue(pausedTime, forKey: UserDefaultsKey.pausedTime)
    }
}
