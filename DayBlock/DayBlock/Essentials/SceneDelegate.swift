//
//  SceneDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        /// Code Base 설정
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        /// UINavigation 추가
        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
        
        let scheduleNavigationController = UINavigationController(rootViewController: ScheduleViewController())
        
        let storageNavigationController = UINavigationController(rootViewController: StorageViewController())
        
        /// UITabBarController 추가
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = GrayScale.mainText
        tabBarController.setViewControllers([
            homeNavigationController,
            scheduleNavigationController,
            storageNavigationController
        ], animated: true)
        
        /// UITabBarItem 추가
        if let items = tabBarController.tabBar.items {
            
            /// homeNavigationController
            items[0].image = UIImage(named: Icon.home)
            items[0].title = "홈"
            
            /// scheduleNavigationController
            items[1].image = UIImage(named: Icon.schedule)
            items[1].title = "계획표"
            
            /// storageNavigationController
            items[2].image = UIImage(named: Icon.storage)
            items[2].title = "저장소"
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

