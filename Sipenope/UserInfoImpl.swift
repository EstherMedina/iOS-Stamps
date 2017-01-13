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
    
    var plistData: [String:String] = [:]
    
    required init(plistData: [String: String]) {
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
    
}

