//
//  RepeInfoImpl.swift
//  Sipenope
//
//  Created by Esther Medina on 8/2/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit
import Parse


class RepeInfoImpl: RepeInfoDAO {
    
    var plistData: [String:NSObject] = [:]
    
    
    required init(plistData: [String: NSObject]) {
        self.plistData = plistData
    }
    
    func setNewRepeInBackground(collectionId: String, collectibleId: String, username: String) {
        
        let object = PFObject(className: self.plistData["classnamerepe"]! as! String)
        object["collectionId"] = collectionId
        object["collectibleId"] = collectibleId
        object["username"] = username
        
        object.saveInBackground()
    }
    
    func loadRepeFromCollection(username: String, collectionId: String, withFunction theFunction: @escaping ([String : Repe])->()) {
        let query = PFQuery(className: self.plistData["classnamerepe"]! as! String)
        query.whereKey("collectionId", equalTo: collectionId )
        query.whereKey("username", equalTo: username )
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    let collectibleId = (object["collectibleId"] != nil) ? (object["collectibleId"] as! String):""
                    
                    let repeInfoAll = Repe(collectionId: collectionId, collectibleId: collectibleId, username: username)
                    
                    theFunction(["repeInfo" : repeInfoAll])
                    
                } //for
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    func loadRepe(username: String, withFunction theFunction: @escaping ([String : Repe])->()) {
        let query = PFQuery(className: self.plistData["classnamerepe"]! as! String)
        query.whereKey("username", equalTo: username )
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    let collectionId = (object["collectionId"] != nil) ? (object["collectionId"] as! String):""
                    let collectibleId = (object["collectibleId"] != nil) ? (object["collectibleId"] as! String):""
                    let username = username
                    
                    let repeInfoAll = Repe(collectionId: collectionId, collectibleId: collectibleId, username: username)
                    
                    theFunction(["repeInfo" : repeInfoAll])
                    
                } //for
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    func loadRepeAllUsers(withFunction theFunction: @escaping ([String : Repe])->()) {
        let query = PFQuery(className: self.plistData["classnamerepe"]! as! String)
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    let collectionId = (object["collectionId"] != nil) ? (object["collectionId"] as! String):""
                    let collectibleId = (object["collectibleId"] != nil) ? (object["collectibleId"] as! String):""
                    let username = (object["username"] != nil) ? (object["username"] as! String) : ""
                    
                    let repeInfoAll = Repe(collectionId: collectionId, collectibleId: collectibleId, username: username)
                    
                    theFunction(["repeInfo" : repeInfoAll])
                    
                } //for
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    
    func loadRepe(username: String, otherCollectibleId: String, withFunction theFunction: @escaping ([String : Repe])->()) {
        let query = PFQuery(className: self.plistData["classnamerepe"]! as! String)
        query.whereKey("username", equalTo: username )
        query.whereKey("collectibleId", equalTo: otherCollectibleId )
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if objects!.count == 1 {
                    let collectionId = (objects![0]["collectionId"] != nil) ? (objects![0]["collectionId"] as! String):""
                    let collectibleId = otherCollectibleId
                    let username = username
                    
                    let repeInfoAll = Repe(collectionId: collectionId, collectibleId: collectibleId, username: username)
                    
                    theFunction(["repeInfo" : repeInfoAll])
                    
                } //if
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    
    

    
}
