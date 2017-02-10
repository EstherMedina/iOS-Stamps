//
//  FacebookInfoDAO.swift
//  Sipenope
//
//  Created by Esther Medina on 16/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit


protocol FacebookInfoDAO {
    var plistData: [String:NSObject] {get set}
    
    init(plistData: [String: NSObject])
    
    func initializeFacebook(applicationLaunchOptions: [AnyHashable : Any]? )
    
    func isUrlIntendedForFacebookSDK(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool

    func activateApp()
    
    func wasIntendedForFacebookSDK(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    
    func wasIntendedForFacebookSDK(app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    
    func isCurrentAccessTokenNil() -> Bool
    
    func logInInBackground(withReadPermissions: [String], withFunction theFunction: @escaping ([String : Any])->())
    
    func callFBSDKGraphRequest(withFunction theFunction: @escaping ([String : Any])->())
}

