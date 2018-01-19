//
//  AppDelegate.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/10/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

@UIApplicationMain
class SDAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let redColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        let greenColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)

        let myColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        print(myColor.isEqualToColor(color: greenColor, withTolerance: 2/255.0))
        
        
        for i in 1...255 {
            
            let x = CGFloat(i)
            if myColor.isEqualToColor(color: greenColor, withTolerance: x/255.0)
            {
                break
            }
            print(x)

        }
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
