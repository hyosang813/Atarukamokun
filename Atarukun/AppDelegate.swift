//
//  AppDelegate.swift
//  当たる鴨君
//
//  Created by 大山 孝 on 2015/10/22.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit
import LogPush

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.clearColor()
        self.window?.rootViewController = MainViewController()
        self.window?.makeKeyAndVisible()
        
        //LogPush init
        LogPush.initApplicationId("59804185856831488", secretKey: "bzfZFIBUIQqysyoQ9gRXEyo1sBuFlWKg", launchOptions: launchOptions)
        LogPush.setDeviceTags()
        LogPush.requestDeviceToken()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) { UIApplication.sharedApplication().applicationIconBadgeNumber = 0 }
    func applicationDidEnterBackground(application: UIApplication) { UIApplication.sharedApplication().applicationIconBadgeNumber = 0 }
    func applicationWillEnterForeground(application: UIApplication) { UIApplication.sharedApplication().applicationIconBadgeNumber = 0 }
    func applicationDidBecomeActive(application: UIApplication) { UIApplication.sharedApplication().applicationIconBadgeNumber = 0 }
    func applicationWillTerminate(application: UIApplication) { UIApplication.sharedApplication().applicationIconBadgeNumber = 0 }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        #if DEBUG
            let env = LPDevelopment
        #else
            let env = LPProduction
        #endif
        LogPush.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken, withEnv: env)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        LogPush.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        LogPush.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}
