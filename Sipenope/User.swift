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
    
    var objectId : String!
    var name: String!
    var nickname : String = ""
    var email: String!
    var image : UIImage?
    var isFriend : Bool = false
    var location : CLLocationCoordinate2D?
    var radius : Double = 100.0

    
    init(objectId : String, name: String, nickname: String, email: String) {
        super.init()
        
        self.objectId = objectId
        self.name = name
        self.nickname = (nickname == "") ? self.getNicknameFromEmail(email: self.email) : nickname
        self.email = email
    }
    
    func getNicknameFromEmail(email: String) -> String {
        return (self.nickname == "") ? (email.components(separatedBy: "@")[0].capitalized) : self.nickname
    }
    
    func setImage(image: UIImage) {
        self.image = image
    }
    
    func setLocationArea(location: CLLocationCoordinate2D, radius: Double) {
        self.location = location
        self.radius = radius
    }
    
    func isFriend(isFriend: Bool) {
        self.isFriend = isFriend
    }
    
    
    
    
}
