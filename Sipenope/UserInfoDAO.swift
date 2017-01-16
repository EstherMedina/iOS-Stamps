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

    func getUsers() -> [User]
    
    func getUsernameFromCurrentUser() -> String
    
    func getObjectidFromCurrentUser() -> String
    
}

