//
//  FacebookInfoImpl.swift
//  Sipenope
//
//  Created by Esther Medina on 16/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit


class FacebookInfoImpl: FacebookInfoDAO {
    var plistData: [String:NSObject] = [:]
    
    required init(plistData: [String: NSObject]) {
        self.plistData = plistData
    }
    
    func initializeFacebook(applicationLaunchOptions: [AnyHashable : Any]? = nil) {
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: applicationLaunchOptions)
    }
    
    func isUrlIntendedForFacebookSDK(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
}
