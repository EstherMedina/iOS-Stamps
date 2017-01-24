//
//  AclInfoImpl.swift
//  Sipenope
//
//  Created by Esther Medina on 16/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//


import Foundation
import UIKit
import Parse


class AclInfoImpl: AclInfoDAO {
    var plistData: [String:NSObject] = [:]
    var getPublicReadAccess: Bool = true
    var withAccessForCurrentUser: Bool = true
    
    
    required init(plistData: [String: NSObject]) {
        self.plistData = plistData
        self.getPublicReadAccess = self.plistData["getPublicReadAccess"]! as! Bool
        self.withAccessForCurrentUser = self.plistData["withAccessForCurrentUser"]! as! Bool
    }
    
    
    //MARK: GET  INFO
    func setPublicReadAccess() {
        let defaultACL = PFACL();
        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = self.getPublicReadAccess
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: self.withAccessForCurrentUser)
    }
}

