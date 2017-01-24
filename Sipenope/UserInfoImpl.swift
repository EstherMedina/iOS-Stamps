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
    
    
    //MARK: LOGIN
    func logInWithUsername(username: String, password: String, alert:Alert) {
        PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameLogInWithUsername), object: nil, userInfo: ["error" : error as Any, "alert": alert])
        })
    }
    
    
    //MARK: CREATE NEW USER
    func createNewUser(username:String, email: String, password: String, alert: Alert) {
        let user = PFUser()
        user.username = username
        user.email = email
        user.password = password
        
        user.signUpInBackground { (success, error) in
            
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameCreateNewUser), object: nil, userInfo: ["error" : error as Any, "alert": alert])
            
        }
    }

    
    
    //MARK: GET  INFO
    func getCurrentUser() {
        var user: User? = nil
        
        if PFUser.current() != nil {
            
            let nickname = (PFUser.current()!.email)!.components(separatedBy: "@")[0].capitalized
            
            user = User(objectId: "", name:  (PFUser.current()!.username)!, nickname: nickname, email:  (PFUser.current()!.email)!)
            let radius = PFUser.current()!["radius"] as! Double
            if let loc = PFUser.current()!["location"] {
                let location = loc as? CLLocationCoordinate2D
                user?.setLocationArea(location: location!, radius: radius)
            } else {
                user?.radius = radius
            }
            
            if let gender = PFUser.current()!["gender"] {
                user?.gender = gender as! Bool
            }
            

            if PFUser.current()!["image"] != nil {
                let image = PFUser.current()!["image"] as! PFFile
                image.getDataInBackground(block: { (imageData, error) in
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        if let imageData = imageData {
                            let userImage = UIImage(data: imageData)!
                            user?.setImage(image: userImage)
                        }
                    }
                    
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameGetCurrentUser), object: nil, userInfo: ["user" : user! as User])
                })
            }
            
        }
        
        
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
    
    func isUserNew(user: Any?) -> Bool {
        var isUserNew = false
        
        if let user = user {
            if user is PFUser {
                isUserNew = (user as! PFUser).isNew
            }
        }
        
        return isUserNew
    }
    
    func requestPasswordResetForEmail(email: String, alert: Alert) {
        PFUser.requestPasswordResetForEmail(inBackground: email, block: { (success, error) in
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameRequestPasswordResetForEmail), object: nil, userInfo: ["error" : error as Any, "alert": alert, "email": email])
        })
    }

    
    //MARK: SAVE
    func saveCurrentUserFromFBDict(dict: [String : AnyObject]) {
        PFUser.current()!.email = (dict["email"] == nil) ? "" : dict["email"] as! String
        PFUser.current()!["username"] = (dict["username"] == nil) ? PFUser.current()!.email : dict["username"] as? String
        PFUser.current()!["gender"] = (dict["gender"] == nil) ? nil : dict["gender"] as? Bool
        PFUser.current()!["radius"] = (dict["radius"] == nil) ? 100 : dict["radius"] as? Double
        PFUser.current()!["nickname"] = (dict["nickname"] == nil) ? (dict["email"] as? String)?.components(separatedBy: "@")[0] : dict["nickname"] as? String
        if dict["picture"] != nil {
            if dict["picture"] is Data {
                let imageData = UIImageJPEGRepresentation(UIImage(data:dict["picture"]! as! Data)!, 0.8)
                let imageFile = PFFile(name: "image.jpg", data: imageData!)
                
                PFUser.current()!["image"] = imageFile
                PFUser.current()!.saveInBackground()

            } else {
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
        } else {
            PFUser.current()!.saveInBackground()
        }
    }

    
    
    //MARK: LOGOUT
    func logOutInBackground() {
        PFUser.logOutInBackground()
    }
    
    func logOutInBackgroundBlock() {
        PFUser.logOutInBackground { (error) in
            if error == nil {
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNamelogOutInBackgroundBlock), object: nil, userInfo: nil)
            }
        }
    }
}

