//
//  collectibleInfoImpl.swift
//  Sipenope
//
//  Created by Esther Medina on 3/2/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit
import Parse


class CollectibleInfoImpl: CollectibleInfoDAO {
    
    var plistData: [String:NSObject] = [:]
    
    
    required init(plistData: [String: NSObject]) {
        self.plistData = plistData
    }
    
    
    //MARK: GET  INFO
    func setNewCollectibleInBackground(collectibleId: String, collectibleName: String, collectibleImage: UIImage?, collectibleCategory: String, collectibleInfo: String, collectionId: String) {

        let object = PFObject(className: self.plistData["classnamecollectible"]! as! String)
        object["collectibleId"] = collectibleId
        object["collectibleName"] = collectibleName
        //object["collectibleImage"] = PFFile(data: Data())
        object["collectibleCategory"] = collectibleCategory
        object["collectibleInfo"] = collectibleInfo
        object["collectionId"] = collectionId

        
        object.saveInBackground()
       
        
    }
    
    func loadCollectiblesFromCollection(collectionId: String) {
        let query = PFQuery(className: self.plistData["classnamecollectible"]! as! String)
        query.whereKey("collectionId", equalTo: collectionId )

        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    let collectibleId = (object["collectibleId"] != nil) ? (object["collectibleId"] as! String):""
                    let collectibleName = (object["collectibleName"] != nil) ? (object["collectibleName"] as! String) : ""
                    //let collectibleImage = UIImage()
                    let collectibleCategory = (object["collectibleCategory"] != nil) ? (object["collectibleCategory"] as! String) : "Default"
                    let collectibleInfo = (object["collectibleInfo"] != nil) ? (object["collectibleInfo"] as! String) : ""
                    let collectionId = (object["collectionId"] != nil) ? (object["collectionId"] as! String) : "Default"
                    
                    let collectibleInfoAll = Collectible(collectibleId: collectibleId, collectibleName: collectibleName, collectibleCategory: collectibleCategory, collectionId: collectionId, collectibleImage: nil, collectibleInfo: collectibleInfo)
                    
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: DAOFactory.notificationNameLoadCollectiblesFromCollection), object: nil, userInfo: ["collectibleInfo" : collectibleInfoAll])
                    
                } //for
            } else {
                print(error.debugDescription)
            }
        }
    }
    
}
