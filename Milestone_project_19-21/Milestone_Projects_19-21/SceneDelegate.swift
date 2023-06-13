//
//  SceneDelegate.swift
//  Milestone_Projects_19-21
//
//  Created by IceR on 13.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowscene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowscene)
        window.rootViewController = RootViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}

