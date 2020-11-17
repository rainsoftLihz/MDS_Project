//
//  AppDelegate.swift
//  MDSTiMmuy
//
//  Created by rainsoft on 2020/11/17.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.frame = UIScreen.main.bounds;
        window?.backgroundColor = UIColor.white;
        
        window?.makeKeyAndVisible();
        gotoHome()
        return true
    }


    func gotoLogin() {
        window?.rootViewController = MDSLoginVC()
    }
    
    func gotoHome() {
        window?.rootViewController = MDSTabBarController();
    }

}

