//
//  AppDelegate.swift
//  Milestone_Projects_7-9
//
//  Created by Айсен Еремеев on 06.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = ViewController()
    window?.backgroundColor = .white
    window?.makeKeyAndVisible()
    return true
  }
}

