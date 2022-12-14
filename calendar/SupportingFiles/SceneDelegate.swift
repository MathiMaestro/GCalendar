//
//  SceneDelegate.swift
//  calendar
//
//  Created by Mathiyalagan S on 20/11/22.
//

import UIKit
import CoreSpotlight

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = getRootViewController()
        window?.makeKeyAndVisible()
    }
    
    private func getRootViewController(with eventId: String? = nil) -> UINavigationController {
        let vc = (UserManager.shared.tokenDetail == nil) ? LoginVC() : LauncherVC(eventId: eventId)
        return UINavigationController(rootViewController: vc)
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
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == CSSearchableItemActionType, let eventId = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            if UserManager.shared.isFirstTime {
                UserManager.shared.spotLightEventId = eventId
                UserManager.shared.isFirstTime = false
            } else {
                window?.rootViewController = getRootVC(for: userActivity, eventId: eventId)
            }
        }
    }
    
    func getRootVC(for userActivity: NSUserActivity, eventId: String) -> UINavigationController? {
            guard let navVC = window?.rootViewController as? UINavigationController, let calendarVC = navVC.viewControllers.first as? CalendarVC else {
                return getRootViewController()
              }
            if let presentedControllers = calendarVC.presentedViewController as? UINavigationController {
                presentedControllers.viewControllers.last?.presentedViewController?.dismiss(animated: false)
                presentedControllers.popToRootViewController(animated: false)
            }
            return UINavigationController(rootViewController: CalendarVC(eventId: eventId))
    }

}

