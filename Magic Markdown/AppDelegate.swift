//
//  AppDelegate.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 5/9/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if NSUserDefaults.standardUserDefaults().objectForKey(Constants.saveOnExit) == nil {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Constants.saveOnExit)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            DocumentManager.sharedInstance.checkforiCloud()
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if NSUserDefaults.standardUserDefaults().boolForKey(Constants.saveOnExit) && DocumentManager.sharedInstance.currentOpenDocument != nil {
            weak var parentView: ConmposeViewController? = UIApplication.sharedApplication().keyWindow!.rootViewController as? ConmposeViewController
            let text: String = parentView!.composeView.getText()
            DocumentManager.sharedInstance.saveWithName((DocumentManager.sharedInstance.currentOpenDocument?.fileURL.lastPathComponent!)!, data: text)
        }
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

