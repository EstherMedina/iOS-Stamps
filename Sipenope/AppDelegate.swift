//
//  AppDelegate.swift
//  Sipenope
//
//  Created by Esther Medina on 10/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var aclInfoDAO : AclInfoDAO?
    var connectInfoDAO: ConnectInfoDAO?
    var facebookInfoDAO: FacebookInfoDAO?


    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.connectInfoDAO = DAOFactory.sharedInstance.connectInfoDAO
        connectInfoDAO?.newConnection()
        
        self.aclInfoDAO = DAOFactory.sharedInstance.aclInfoDAO
        aclInfoDAO?.setPublicReadAccess()
        
        self.facebookInfoDAO = DAOFactory.sharedInstance.facebookInfoDAO
        self.facebookInfoDAO?.initializeFacebook(applicationLaunchOptions: launchOptions)
        
        return (self.facebookInfoDAO?.wasIntendedForFacebookSDK(application: application, didFinishLaunchingWithOptions: launchOptions))!
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.facebookInfoDAO?.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return (self.facebookInfoDAO?.isUrlIntendedForFacebookSDK(application: application, openURL: url as NSURL, sourceApplication: sourceApplication, annotation: annotation as AnyObject?))!
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.facebookInfoDAO?.activateApp()
    }

    
    
    
    
    
    
    
    
    
    
    /*
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.connectInfoDAO = DAOFactory.sharedInstance.connectInfoDAO
        connectInfoDAO?.newConnection()
        
        self.aclInfoDAO = DAOFactory.sharedInstance.aclInfoDAO
        aclInfoDAO?.setPublicReadAccess()
       
        self.facebookInfoDAO = DAOFactory.sharedInstance.facebookInfoDAO
        self.facebookInfoDAO?.initializeFacebook(applicationLaunchOptions: launchOptions)

        return (self.facebookInfoDAO?.wasIntendedForFacebookSDK(application: application, didFinishLaunchingWithOptions: launchOptions))!
    }
    
    

    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }
    
    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------
    
    
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        //if (url.scheme?.hasPrefix("fb") ?? false) && url.host == "authorize" {
            
            return (self.facebookInfoDAO?.isUrlIntendedForFacebookSDK(application: application, openURL: url as NSURL, sourceApplication: sourceApplication, annotation: annotation as AnyObject?))!
        /*} else {
            return false
        }*/
    }

    /*func application(application: UIApplication,
                     openURL url: NSURL,
                     sourceApplication: String?,
                     annotation: AnyObject?) -> Bool {
        if (url.scheme?.hasPrefix("fb") ?? false) && url.host == "authorize" {
            
            return (self.facebookInfoDAO?.isUrlIntendedForFacebookSDK(application: application, openURL: url, sourceApplication: sourceApplication, annotation: annotation))!
        } else {
            return false
        }
    }*/
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return (self.facebookInfoDAO?.wasIntendedForFacebookSDK(app: app, open: url, options: options))!
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        self.facebookInfoDAO?.activateApp()
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
        self.facebookInfoDAO?.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
 
 */
    

}

