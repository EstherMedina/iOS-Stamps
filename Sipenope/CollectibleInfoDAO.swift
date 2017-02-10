//
//  CollectibleInfoDAO.swift
//  Sipenope
//
//  Created by Esther Medina on 3/2/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit


protocol CollectibleInfoDAO {
    var plistData: [String:NSObject] {get set}
    
    init(plistData: [String: NSObject])
    
    func setNewCollectibleInBackground(collectibleId: String, collectibleName: String, collectibleImage: UIImage?, collectibleCategory: String, collectibleInfo: String, collectionId: String)

    func loadCollectiblesFromCollection(collectionId: String, withFunction theFunction: @escaping ([String : Collectible])->())
}

