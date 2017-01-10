//
//  User.swift
//  Sipenope
//
//  Created by Esther Medina on 10/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//
import UIKit
import CoreLocation

class User: NSObject {
    
    var name: String!
    var gender : Bool?
    var image : UIImage?
    var birthdate : Date?
    var email: String!
    var objectId : String!
    var isFriend : Bool = false
    var nickName : String?
    var location : CLLocationCoordinate2D?
    var radius : Double
    
    
    init(name: String, email: String, objectId: String, radius: Double, gender: Bool?, image: UIImage?, birthdate: Date?) {
        self.name = name
        self.email = email
        self.objectId = objectId
        self.gender = gender
        self.image = image
        self.birthdate = birthdate
        self.radius = radius
    }
    
    
}
