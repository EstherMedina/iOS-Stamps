//
//  AppDelegate.swift
//  Sipenope
//
//  Created by Esther Medina on 10/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import UIKit
import Parse
import Bolts



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "f9e39ebf8fa0a4aaf9a8111d4c504b630d8ee3df"
            ParseMutableClientConfiguration.clientKey = "13939de200f1cefbbc6bf3acc385ba67689aa5be"
            ParseMutableClientConfiguration.server = "http://ec2-54-229-104-119.eu-west-1.compute.amazonaws.com:80/parse"
            ParseMutableClientConfiguration.isLocalDatastoreEnabled = true
        })
        Parse.enableLocalDatastore()
        Parse.initialize(with: parseConfiguration)
        
        
        
        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************
        
        //PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true
        
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        /*if application.applicationState != UIApplicationState.background {
         // Track an app open here if we launch with a push, unless
         // "content_available" was used to trigger a background push (introduced in iOS 7).
         // In that case, we skip tracking here to avoid double counting the app-open.
         
         let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
         let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
         var noPushPayload = false;
         if let options = launchOptions {
         noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
         }
         if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
         PFAnalytics.trackAppOpened(launchOptions: launchOptions)
         }
         }
         */
        
        //
        //  Swift 1.2
        //
        //        if application.respondsToSelector("registerUserNotificationSettings:") {
        //            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        //            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //            application.registerForRemoteNotifications()
        //        } else {
        //            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
        //            application.registerForRemoteNotificationTypes(types)
        //        }
        
        //
        //  Swift 2.0
        //l
        //        if #available(iOS 8.0, *) {
        //l            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        //            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //            application.registerForRemoteNotifications()
        //        } else {
        //            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
        //            application.registerForRemoteNotificationTypes(types)
        //        }
        
        
        //PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        return true
        //return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
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
    
    
    /*func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
     }*/
    
    /*func application(application: UIApplication,
                     openURL url: NSURL,
                     sourceApplication: String?,
                     annotation: AnyObject?) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
    }
 */


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

