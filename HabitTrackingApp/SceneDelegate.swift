//
//  SceneDelegate.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 30/10/2021.
//

import UIKit
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    fileprivate func userActivity(_ windowScene: UIWindowScene) {
        if UserState.getUserState(){
            let vc = UINavigationController(rootViewController: HomeVC(nibName: "HomeVC", bundle: nil)) //LoginVC(nibName: "LoginVC", bundle: nil)
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = vc
            self.window = window
            self.window?.makeKeyAndVisible()
        }else{
            
            //            let vc = UINavigationController(rootViewController: HomeVC(nibName: "HomeVC", bundle: nil)) //LoginVC(nibName: "LoginVC", bundle: nil)
            //
            //            let window = UIWindow(windowScene: windowScene)
            //            window.rootViewController = vc
            //            self.window = window
            //            self.window?.makeKeyAndVisible()
            
            
            let vc = UINavigationController(rootViewController:LoginVC(nibName: "LoginVC", bundle: nil))
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = vc
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .update, object: nil)
        _ = UserState.getUserState()
        userActivity(windowScene)
        
        
        
    }
    
    @objc private func updateViews(){
        _ = UserState.getUserState()
        if UserState.getUserState(){
            let vc = UINavigationController(rootViewController: HomeVC(nibName: "HomeVC", bundle: nil))
            window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }else{
            let vc = UINavigationController(rootViewController:LoginVC(nibName: "LoginVC", bundle: nil))
            window?.rootViewController = vc
            //self.window = window
            self.window?.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
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


}

