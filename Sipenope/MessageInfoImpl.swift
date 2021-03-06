//
//  MessageInfoImpl.swift
//  Sipenope
//
//  Created by Esther Medina on 11/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit
import Parse


class MessageInfoImpl: MessageInfoDAO {
    
    var plistData: [String:NSObject] = [:]
    
    
    required init(plistData: [String: NSObject]) {
        self.plistData = plistData
    }
    
    
    //MARK: GET  INFO
    func setNewMessageInBackground(senderId: String, receiverId: String, message: String) {
        let messageText = message
        if messageText != ""{
            let object = PFObject(className: self.plistData["classnamemessage"]! as! String)
            object["senderId"] = senderId
            object["receiverId"] = receiverId
            object["message"] = message
            object.saveInBackground()
        }
        
    }

    
    func loadMessages(userId: String, myUserId: String, withFunction theFunction: @escaping ([String : Message])->()) {
        
        let querySender = PFQuery(className: self.plistData["classnamemessage"]! as! String)
        querySender.whereKey("senderId", equalTo: userId )
        querySender.whereKey("receiverId", equalTo: myUserId )
        
        let queryReceiver = PFQuery(className: self.plistData["classnamemessage"]! as! String)
        queryReceiver.whereKey("senderId", equalTo: myUserId )
        queryReceiver.whereKey("receiverId", equalTo: userId )
        
        
        let query = PFQuery.orQuery(withSubqueries: [querySender, queryReceiver])
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
               
                for object in objects! {
                    //let messageId = object.objectId
                    let messageText = object["message"] != nil ? object["message"] as! String : ""
                    let dateMessage = object.createdAt
                    let senderId = object["senderId"] as! String
                    let receiverId = object["receiverId"] as! String
                    
                    let messageInfo = Message(objectId: "", senderId: senderId, receiverId: receiverId, message: messageText, image: nil, creationDate: dateMessage!)
                    
                    theFunction(["messageInfo" : messageInfo])
                    
                } //for
                
                
            } else {
                print(error.debugDescription)
            }
        }
        
    }


        
}

