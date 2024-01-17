//
//  AppDelegate.swift
//  Daily_Planner
//
//  Created by Daniil on 17.01.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ActivityListViewController()
        window?.makeKeyAndVisible()
        return true
    }

}
