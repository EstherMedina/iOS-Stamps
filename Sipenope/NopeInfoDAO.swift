//
//  NopeInfoDAO.swift
//  Sipenope
//
//  Created by Esther Medina on 8/2/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit


protocol NopeInfoDAO {
    var plistData: [String:NSObject] {get set}
    
    init(plistData: [String: NSObject])
    
    func setNewNopeInBackground(collectionId: String, collectibleId: String, username: String)
    
    func loadNopeFromCollection(username: String, collectionId: String)
    
    func loadNope(username: String)
    
    func loadNopeAllUsers()
}

