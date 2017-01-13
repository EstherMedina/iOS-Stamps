//
//  Message.swift
//  Sipenope
//
//  Created by Esther Medina on 10/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//
import UIKit
import Foundation


class Message: NSObject {
    
    var objectId: String!
    var senderId: String!
    var receiverId: String!
    var message : String?
    var image: UIImage?
    var creationDate: Date!
    
    
    init(objectId: String, senderId: String, receiverId: String, message: String?, image: UIImage?, creationDate: Date) {
        self.objectId = objectId
        self.senderId = senderId
        self.receiverId = receiverId
        if message != nil {
            self.message = message
            self.image = nil
        } else {
            self.message = nil
            self.image = image
        }
        self.creationDate = creationDate
    }
    
    
}
