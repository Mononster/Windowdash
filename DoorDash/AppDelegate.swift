//
//  AppDelegate.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        self.window?.frame = UIScreen.main.bounds
        self.window?.backgroundColor = UIColor.white
        return true
    }
}

