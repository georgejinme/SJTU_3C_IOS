//
//  AppDelegate.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/10.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let soundID = "appid=561d1815"
        IFlySpeechUtility.createUtility(soundID)
        
        EaseMob.sharedInstance().registerSDKWithAppKey("gougoumemeda#3c", apnsCertName: "com.gougoumemeda.3c")
        EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("user") == nil){
            EaseMob.sharedInstance().chatManager.asyncRegisterNewAccount("3ccontrol", password: "941102", withCompletion: nil, onQueue: nil)
            NSUserDefaults.standardUserDefaults().setObject("3ccontrol", forKey: "user")
            NSUserDefaults.standardUserDefaults().setObject("941102", forKey: "password")
        }
        let username = NSUserDefaults.standardUserDefaults().objectForKey("user") as! String
        let password = NSUserDefaults.standardUserDefaults().objectForKey("password") as! String
        EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(username, password: password, completion: {_, error in
            if (error != nil){
                print("login success")
            }else{
                print(error)
            }
        }, onQueue: nil)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

