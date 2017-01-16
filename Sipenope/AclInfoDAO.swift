//
//  AclInfoDAO.swift
//  Sipenope
//
//  Created by Esther Medina on 16/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit


protocol AclInfoDAO {
    var plistData: [String:NSObject] {get set}
    var getPublicReadAccess: Bool {get set}
    var withAccessForCurrentUser: Bool {get set}

    
    init(plistData: [String: NSObject])

    func setPublicReadAccess()
}
