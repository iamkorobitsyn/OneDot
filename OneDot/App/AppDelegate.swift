//
//  AppDelegate.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = MainVC()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
        UserDefaultsManager.shared.userDefaults.synchronize()
    }
}

