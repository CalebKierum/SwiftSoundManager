//
//  AppDelegate.swift
//  SoundManager
//
//  Created by Caleb Kierum on 3/30/16.
//  Copyright © 2016 Broccoli Presentations. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        Sequencer.pause()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        Sequencer.pause()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        Sequencer.play()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

