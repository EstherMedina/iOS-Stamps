//
//  DAOFactory.swift
//  Sipenope
//
//  Created by Esther Medina on 10/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit


class DAOFactory: NSObject {

    static let notificationNameLoadMessages = "MessagesLoaded"
    static let notificationNameLogInBackground = "LogInEnded"
    static let notificationNameCallFBSDKGraphRequest = "FBSDKGraphRequestCalled"
    static let notificationNameCreateNewUser = "NewUserCreated"
    static let notificationNameLogInWithUsername = "LogInWithUsernameEnded"
    static let notificationNameRequestPasswordResetForEmail = "RequestPasswordResetForEmailEnded"
    static let notificationNameGetCurrentUser = "GetCurrentUserEnded"
    static let notificationNamelogOutInBackgroundBlock = "LogOutInBackgroundBlockEnded"
    static let notificationNameSaveCurrentUserFromFBDict = "SaveCurrentUserFromFBDictEnded"
    static let notificationNameLoadCollectiblesFromCollection = "LoadCollectiblesFromCollectionEnded"
    static let notificationNameLoadNopeFromCollection = "LoadNopeFromCollectionEnded"
    static let notificationNameLoadRepeFromCollection = "LoadRepeFromCollectionEnded"
    static let notificationNameLoadNope = "LoadNopeEnded"
    static let notificationNameLoadRepe = "LoadRepeEnded"
    static let notificationNameLoadNopeAllUsers = "LoadNopeAllUsersEnded"
    static let notificationNameLoadRepeAllUsers = "LoadRepeAllUsersEnded"
    static let notificationNameLoadRepeAll = "LoadRepeAllEnded"
    static let notificationNameLoadNopeAll = "LoadNopeAllEnded"
    static let notificationNameUsersIdInRadius = "UsersIdInRadiusEnded"
    
    
    
    

    
    static let sharedInstance: DAOFactory = DAOFactory()
    var connectInfoDAO: ConnectInfoDAO?
    var aclInfoDAO: AclInfoDAO?
    var facebookInfoDAO: FacebookInfoDAO?
    var userInfoDAO: UserInfoDAO?
    var messageInfoDAO: MessageInfoDAO?
    var collectibleInfoDAO: CollectibleInfoDAO?
    var nopeInfoDAO: NopeInfoDAO?
    var repeInfoDAO: RepeInfoDAO?
    
    
    var plistData: [String: NSObject] = [:] //Our data
    

    override init() {
        super.init()
        
        readPropertyList(name: "SipeNope", ext: "plist")
        if plistData != [:]{
            if plistData["datastore"] as! String == "Parse" {
                if (plistData["classnameuser"] != nil) {
                    self.userInfoDAO = UserInfoImpl(plistData: self.plistData)
                }
                if (plistData["classnamemessage"] != nil) {
                    self.messageInfoDAO = MessageInfoImpl(plistData: self.plistData)
                }
                if (plistData["classnamecollectible"] != nil) {
                    self.collectibleInfoDAO = CollectibleInfoImpl(plistData: self.plistData)
                }
                if (plistData["classnamenope"] != nil) {
                    self.nopeInfoDAO = NopeInfoImpl(plistData: self.plistData)
                }
                if (plistData["classnamerepe"] != nil) {
                    self.repeInfoDAO = RepeInfoImpl(plistData: self.plistData)
                }
                self.connectInfoDAO = ConnectInfoImpl(plistData: self.plistData)
                self.aclInfoDAO = AclInfoImpl(plistData: self.plistData)
                self.facebookInfoDAO = FacebookInfoImpl(plistData: self.plistData)
            }
        }
    }
    
    
    func readPropertyList(name: String, ext: String)  {
        var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        
        let plistPath: String? = Bundle.main.path(forResource: name, ofType: ext)! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {//convert the data to a dictionary and handle errors.
            self.plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String:NSObject]
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListForamt)")
        }
        
        
        
    }

    
    
    


}
