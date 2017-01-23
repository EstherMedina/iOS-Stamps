//
//  UserInfoImpl.swift
//  Sipenope
//
//  Created by Esther Medina on 10/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit
import Parse


class UserInfoImpl: UserInfoDAO {
    
    var plistData: [String:NSObject] = [:]
    
    required init(plistData: [String: NSObject]) {
        self.plistData = plistData
    }
   
    
    func getUsers() -> [User] {
        return []
    }
    
    func getUsernameFromCurrentUser() -> String {
        return (PFUser.current()?.username)!
    }
    
    func getObjectidFromCurrentUser() -> String {
        return (PFUser.current()?.objectId)!
    }
    
    func isCurrentUserNil() -> Bool {
        var isNil = true
        isNil = (PFUser.current() == nil) ? true : false
        
        return isNil
    }
    
    func logOutInBackground() {
        PFUser.logOutInBackground()
    }
    
    func isUserNew(user: Any?) -> Bool {
        var isUserNew = false
        
        if let user = user {
            if user is PFUser {
                isUserNew = (user as! PFUser).isNew
            }
        }
        
        return isUserNew
    }
    
    func savePFUserFromFBDict(dict: [String : AnyObject]) {
        PFUser.current()!.email = dict["email"] as? String
        PFUser.current()!["username"] = PFUser.current()!.email
        PFUser.current()!["gender"] = true
        PFUser.current()!["radius"] = 100
        PFUser.current()!["nickname"] = (dict["email"] as? String)?.components(separatedBy: "@")[0]

        let pictureURL = ((dict["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"] as! String
        let URLRequest = NSURL(string: pictureURL)
        let URLRequestNeeded = NSURLRequest(url: URLRequest! as URL)
        NSURLConnection.sendAsynchronousRequest(URLRequestNeeded as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) in
            
            if error == nil {
                let imageData = UIImageJPEGRepresentation(UIImage(data:data!)!, 0.8)
                let imageFile = PFFile(name: "image.jpg", data: imageData!)
                
                PFUser.current()!["image"] = imageFile
                
            }
            PFUser.current()!.saveInBackground()
        })
    }
    
    func createNewUser(username:String, email: String, password: String, alert: Alert) {
        let user = PFUser()
        user.username = username
        user.email = email
        user.password = password

        user.signUpInBackground { (success, error) in
       
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameCreateNewUser), object: nil, userInfo: ["error" : error as Any, "alert": alert])
            
        }
    }
    
    
    func logInWithUsername(username: String, password: String, alert:Alert) {
        PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameLogInWithUsername), object: nil, userInfo: ["error" : error as Any, "alert": alert])
        })
    }
    
    func requestPasswordResetForEmail(email: String, alert: Alert) {
        PFUser.requestPasswordResetForEmail(inBackground: email, block: { (success, error) in
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameRequestPasswordResetForEmail), object: nil, userInfo: ["error" : error as Any, "alert": alert, "email": email])
        })
    }

}

