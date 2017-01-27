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
            var userInfo:[String: AnyObject]
            userInfo = ["error":error as AnyObject, "alert": alert]
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameLogInWithUsername), object: nil, userInfo: userInfo)
            
        })
    }
    
    
    //MARK: CREATE NEW USER
    func createNewUser(username:String, email: String, password: String, alert: Alert) {
        let user = PFUser()
        user.username = username
        user.email = email
        user.password = password
        
        
        user.signUpInBackground { (success, error) in
            var userInfo:[String: AnyObject]
            userInfo = ["error":error as AnyObject, "alert": alert]
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameCreateNewUser), object: nil, userInfo: userInfo)
            
            if error == nil {
                
                PFGeoPoint.geoPointForCurrentLocation(inBackground: { (geopoint, error) in
                    if error == nil {
                        print("got location successfully")
                        PFUser.current()!.setValue(geopoint, forKey:"location")
                        PFUser.current()!.saveInBackground()
                        
                    } else {
                        print(error.debugDescription)
                    }

                })
            }
            
        }
    }

    
    
    //MARK: GET  INFO
    func getCurrentUser() {
        var user: User? = nil
        
        if PFUser.current() != nil {
            
            let nickname = (PFUser.current()!.email)!.components(separatedBy: "@")[0].capitalized
            
            user = User(objectId: "", name:  (PFUser.current()!.username)!, nickname: nickname, email:  (PFUser.current()!.email)!)
            if let loc = PFUser.current()!["location"] {
                let location = loc as? PFGeoPoint
                let locationCoord = CLLocationCoordinate2D(latitude: (location?.latitude)!, longitude: (location?.longitude)!)
                
                user?.location = locationCoord
            }
            
            if let radius = PFUser.current()!["radius"]
            {
                user?.radius = Double(radius as! Int)
            }
            
            
            if let gender = PFUser.current()!["gender"] {
                user?.gender = (gender as! Bool)
            }
            

            if let picture = PFUser.current()!["image"] {
                let image = picture as! PFFile
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
            } else {
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameGetCurrentUser), object: nil, userInfo: ["user" : user! as User])
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
        if let loc = dict["location"] {
            let location = loc as! CLLocationCoordinate2D
            PFUser.current()!["location"] = PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
        } else {
            PFGeoPoint.geoPointForCurrentLocation(inBackground: { (geopoint, error) in
                if error == nil {
                    print("got location successfully")
                    PFUser.current()!.setValue(geopoint, forKey:"location")
                    PFUser.current()!.saveInBackground()
                } else {
                    print(error.debugDescription)
                }
                
            })

        }
        
        PFUser.current()!.email = (dict["email"] == nil) ? "" : dict["email"] as! String
        PFUser.current()!["username"] = (dict["username"] == nil) ? PFUser.current()!.email : dict["username"] as? String
        if dict["gender"] != nil {
            PFUser.current()!["gender"] = dict["gender"] as? Bool
        }
        PFUser.current()!["radius"] = (dict["radius"] == nil) ? 100 : dict["radius"] as? Double
        PFUser.current()!["nickname"] = (dict["nickname"] == nil) ? (dict["email"] as? String)?.components(separatedBy: "@")[0] : dict["nickname"] as? String
        if dict["picture"] != nil {
            if dict["picture"] is Data {
                let imageData = UIImageJPEGRepresentation(UIImage(data:dict["picture"]! as! Data)!, 0.8)
                let imageFile = PFFile(name: "image.jpg", data: imageData!)
                
                PFUser.current()!["image"] = imageFile
                PFUser.current()!.saveInBackground(block: { (result, error) in
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameSaveCurrentUserFromFBDict), object: nil, userInfo: [:])
                })


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
                    PFUser.current()!.saveInBackground(block: { (result, error) in
                        NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameSaveCurrentUserFromFBDict), object: nil, userInfo: [:])
                    })

                })
            }
        } else {
            PFUser.current()!.saveInBackground(block: { (result, error) in
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameSaveCurrentUserFromFBDict), object: nil, userInfo: [:])
            })
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

