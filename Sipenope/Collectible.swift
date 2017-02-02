//
//  Collectible.swift
//  Sipenope
//
//  Created by Esther Medina on 2/2/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import UIKit
import CoreLocation

class Collectible: NSObject {
    
    var collectibleId: String!
    var collectibleName: String!
    var collectibleImage : UIImage?
    var collectibleCategory: String!
    var collectibleInfo : String?
    var collectionId : String!

    
    
    init(collectibleId : String, collectibleName: String, collectibleCategory: String, collectionId: String, collectibleImage: UIImage?, collectibleInfo: String?) {
        
        super.init()
        
        self.collectibleId = collectibleId
        self.collectibleName = collectibleName
        self.collectibleImage = collectibleImage
        self.collectibleCategory = collectibleCategory
        self.collectibleInfo = collectibleInfo
        self.collectionId = collectionId
        
    }
    
}

