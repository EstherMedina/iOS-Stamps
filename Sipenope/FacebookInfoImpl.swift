//
//  FacebookInfoImpl.swift
//  Sipenope
//
//  Created by Esther Medina on 16/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit
//import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit



class FacebookInfoImpl: FacebookInfoDAO {
    var plistData: [String:NSObject] = [:]
    
    required init(plistData: [String: NSObject]) {
        self.plistData = plistData
    }
    
    
    //MARK: INITIALIZE,  ACTIVATE, LOGIN
    func initializeFacebook(applicationLaunchOptions: [AnyHashable : Any]? = nil) {
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: applicationLaunchOptions)
    }
    
    func activateApp() {
        FBSDKAppEvents.activateApp()
    }
    
       
    func logInInBackground(withReadPermissions: [String], withFunction theFunction: @escaping ([String : Any])->()) {
        PFFacebookUtils.logInInBackground(withReadPermissions: withReadPermissions) { (user, error) in
            if error != nil {
                //process error
                print(error.debugDescription)
                return
            }
            else
            {
                //process ok
                //llamar a la funcion lambda
                theFunction(["user" : user as Any , "error" : error as AnyObject])
            }
        }
        
    }

    
    
    //MARK: GET  INFO
    func isUrlIntendedForFacebookSDK(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    

    func wasIntendedForFacebookSDK(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func wasIntendedForFacebookSDK(app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func isCurrentAccessTokenNil() -> Bool {
        var isCurrentAccessTokenNil = true
        
        isCurrentAccessTokenNil = (FBSDKAccessToken.current() == nil) ? true : false
        
        return isCurrentAccessTokenNil
    }
    
    
    func callFBSDKGraphRequest(withFunction theFunction: @escaping ([String : Any])->()) {
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"])
        //let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"username"])
        //let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"username"], tokenString: nil, version: nil, httpMethod: "GET")
        request?.start(completionHandler: { (conecction, result, error) in
            if (error == nil){
                let dict = result as! [String : AnyObject]
                
                //process ok
                theFunction(["dict" : dict as [String : AnyObject]])
            }

        })
    }
    
}
