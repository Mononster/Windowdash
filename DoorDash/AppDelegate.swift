//
//  AppDelegate.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SwiftDate
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //ApplicationEnvironment.logout()
        SwiftDate.defaultRegion = Region.local
        if let storedEnvironment
            = ApplicationEnvironment.restore(from: UserDefaults.standard) {
            ApplicationEnvironment.replaceCurrentEnvironment(storedEnvironment)
            ApplicationEnvironment.replaceCurrentEnvironment(mainBundle: Bundle.main)
        } else {
            #if DEBUG
            let env = Environment.latest
            #else
            let env = Environment.production
            #endif
            ApplicationEnvironment.pushEnvironment(env)
        }
        
        ApplicationEnvironment.current.dataStore.loadStore {

        }

        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        self.window?.frame = UIScreen.main.bounds
        self.window?.backgroundColor = UIColor.white
        ApplicationDependency.manager.coordinator.start(window: self.window!)
        print(UUID().uuidString)
        return true
    }
}

