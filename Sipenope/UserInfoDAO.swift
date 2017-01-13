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
    var plistData: [String:String] {get set}
    
    init(plistData: [String: String]) 

    func getUsers() -> [User]
    
    func getUsernameFromCurrentUser() -> String
    
    func getObjectidFromCurrentUser() -> String
    
}

