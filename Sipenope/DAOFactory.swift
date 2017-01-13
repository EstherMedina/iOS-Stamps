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

    static  let notificationNameLoadMessages = "MessagesLoaded"
    static let sharedInstance: DAOFactory = DAOFactory()
    var connectInfoDAO: ConnectInfoDAO?
    var userInfoDAO: UserInfoDAO?
    var messageInfoDAO: MessageInfoDAO?
    
    var plistData: [String: String] = [:] //Our data
    

    override init() {
        super.init()
        
        readPropertyList(name: "SipeNope", ext: "plist")
        if plistData != [:]{
            if plistData["datastore"] == "Parse" {
                if (plistData["classnameuser"] != nil) {
                    self.userInfoDAO = UserInfoImpl(plistData: self.plistData)
                }
                if (plistData["classnamemessage"] != nil) {
                    self.messageInfoDAO = MessageInfoImpl(plistData: self.plistData)
                }
                self.connectInfoDAO = ConnectInfoImpl()
            }
        }
    }
    
    
    func readPropertyList(name: String, ext: String)  {
        var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        
        let plistPath: String? = Bundle.main.path(forResource: name, ofType: ext)! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {//convert the data to a dictionary and handle errors.
            self.plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String:String]
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListForamt)")
        }
        
        
        
    }

    
    
    


}
