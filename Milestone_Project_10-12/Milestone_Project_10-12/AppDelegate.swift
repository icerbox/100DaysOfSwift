//
//  AppDelegate.swift
//  Milestone_Project_10-12
//
//  Created by Айсен Еремеев on 25.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      let rootNavigationController = UINavigationController(rootViewController: RootViewController())
    
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootViewController = rootNavigationController
//      window?.rootViewController = RootViewController()
      window?.backgroundColor = .white
      window?.makeKeyAndVisible()
      return true
    }

}

