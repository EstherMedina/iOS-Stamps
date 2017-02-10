//
//  NopeInfoImpl.swift
//  Sipenope
//
//  Created by Esther Medina on 8/2/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit
import Parse


class NopeInfoImpl: NopeInfoDAO {
    
    var plistData: [String:NSObject] = [:]
    
    
    required init(plistData: [String: NSObject]) {
        self.plistData = plistData
    }
    
    
    //MARK: GET  INFO
    func setNewNopeInBackground(collectionId: String, collectibleId: String, username: String) {
        
        let object = PFObject(className: self.plistData["classnamenope"]! as! String)
        object["collectionId"] = collectionId
        object["collectibleId"] = collectibleId
        object["username"] = username

        object.saveInBackground()
    }
    
    func loadNopeFromCollection(username: String, collectionId: String, withFunction theFunction: @escaping ([String : Nope])->()) {
        let query = PFQuery(className: self.plistData["classnamenope"]! as! String)
        query.whereKey("collectionId", equalTo: collectionId )
        query.whereKey("username", equalTo: username )
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    let collectibleId = (object["collectibleId"] != nil) ? (object["collectibleId"] as! String):""
                    
                    let nopeInfoAll = Nope(collectionId: collectionId, collectibleId: collectibleId, username: username)
                    
                    theFunction(["nopeInfo" : nopeInfoAll])
                    
                } //for
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    func loadNope(username: String, withFunction theFunction: @escaping ([String : Nope])->()) {
        let query = PFQuery(className: self.plistData["classnamenope"]! as! String)
        query.whereKey("username", equalTo: username )
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    let collectionId = (object["collectionId"] != nil) ? (object["collectionId"] as! String):""
                    let collectibleId = (object["collectibleId"] != nil) ? (object["collectibleId"] as! String):""
                    let username = username
                    
                    let nopeInfoAll = Nope(collectionId: collectionId, collectibleId: collectibleId, username: username)
                    
                    theFunction(["nopeInfo" : nopeInfoAll])
                    
                } //for
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    func loadNope(username: String, otherCollectibleId: String, withFunction theFunction: @escaping ([String : Nope])->()) {
        let query = PFQuery(className: self.plistData["classnamenope"]! as! String)
        query.whereKey("username", equalTo: username )
        query.whereKey("collectibleId", equalTo: otherCollectibleId )
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if objects!.count == 1 {
                    let collectionId = (objects![0]["collectionId"] != nil) ? (objects![0]["collectionId"] as! String):""
                    let collectibleId = otherCollectibleId
                    let username = username
                    
                    let nopeInfoAll = Nope(collectionId: collectionId, collectibleId: collectibleId, username: username)
                    
                    theFunction(["nopeInfo" : nopeInfoAll])
                    
                } //if
            } else {
                print(error.debugDescription)
            }
        }
    }

    
    func loadNopeAllUsers(withFunction theFunction: @escaping ([String : Nope])->()) {
        let query = PFQuery(className: self.plistData["classnamenope"]! as! String)
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    let collectionId = (object["collectionId"] != nil) ? (object["collectionId"] as! String):""
                    let collectibleId = (object["collectibleId"] != nil) ? (object["collectibleId"] as! String):""
                    let username = (object["username"] != nil) ? (object["username"] as! String) : ""
                    
                    let nopeInfoAll = Nope(collectionId: collectionId, collectibleId: collectibleId, username: username)
                    
                    theFunction(["nopeInfo" : nopeInfoAll])
                    
                } //for
            } else {
                print(error.debugDescription)
            }
        }
    }

 
    
}

