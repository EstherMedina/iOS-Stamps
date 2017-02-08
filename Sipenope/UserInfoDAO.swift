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
    
    func getCurrentUser()
    
    func getUsersIdInRadius(radius: Double) 

    func getUsers() -> [User]
    
    func getUsernameFromCurrentUser() -> String
    
    func getObjectidFromCurrentUser() -> String
    
    func isCurrentUserNil() -> Bool
    
    func logOutInBackground()
    
    func logOutInBackgroundBlock()
    
    func isUserNew(user: Any?) -> Bool
    
    func saveCurrentUserFromFBDict(dict: [String : AnyObject])
    
    func createNewUser(username:String, email: String, password: String, alert: Alert)
    
    func logInWithUsername(username: String, password: String, alert:Alert)
    
    func requestPasswordResetForEmail(email: String, alert: Alert)
    
}

