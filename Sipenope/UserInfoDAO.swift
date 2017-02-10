//
//  UserInfoDAO.swift
//  Sipenope
//
//  Created by Esther Medina on 10/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit


protocol UserInfoDAO {
    var plistData: [String:NSObject] {get set}
    
    init(plistData: [String: NSObject])
    
    func getCurrentUser(withFunction theFunction: @escaping ([String : User])->())
    
    func getUsersIdInRadius(radius: Double, withFunction theFunction: @escaping ([String : User])->())

    func getUsers() -> [User]
    
    func getUsernameFromCurrentUser() -> String
    
    func getObjectidFromCurrentUser() -> String
    
    func isCurrentUserNil() -> Bool
    
    func isUserNil(user: Any?) -> Bool
    
    func logOutInBackground()
    
    func logOutInBackgroundBlock(withFunction theFunction: @escaping ()->())
    
    func isUserNew(user: Any?) -> Bool
    
    func saveCurrentUserFromFBDict(dict: [String : AnyObject], withFunction theFunction: @escaping ()->())
    
    func createNewUser(username:String, email: String, password: String, alert: Alert, withFunction theFunction: @escaping ([String : Any])->()) 
    
    func logInWithUsername(username: String, password: String, alert:Alert, withFunction theFunction: @escaping ([String : Any])->())
    
    func requestPasswordResetForEmail(email: String, alert: Alert, withFunction theFunction: @escaping ([String : Any])->())
    
}

