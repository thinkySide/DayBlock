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
        let scheduleNavigationController = UINavigationController(rootViewController: ScheduleViewController())
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
            items[1].title = "계획표"
            
            // storageNavigationController
            items[2].image = UIImage(named: Icon.storage)
            items[2].title = "저장소"
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        //
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        //
    }

    func sceneWillResignActive(_ scene: UIScene) {
        //
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // 여기서 나간 시점과의 차이 계산해서 이것저것 반영할 것.
        
        let timestamp = Date().timeIntervalSince1970
        print(timestamp)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        // 나가는 시점의 시간 계산
        let timestamp = Date().timeIntervalSince1970
        print(timestamp)
    }
}
