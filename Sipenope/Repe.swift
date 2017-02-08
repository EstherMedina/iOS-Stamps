//
//  Repe.swift
//  Sipenope
//
//  Created by Esther Medina on 8/2/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import UIKit
import CoreLocation

class Repe: NSObject {
    
    var collectionId : String!
    var collectibleId: String!
    var username: String!

    init(collectionId: String, collectibleId : String, username: String) {
        
        super.init()
        
        self.collectionId = collectionId
        self.collectibleId = collectibleId
        self.username = username
        
    }
    
}
