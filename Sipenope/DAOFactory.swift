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

    static let shareInstance: DAOFactory = DAOFactory()
    var userInfoDAO: UserInfoDAO?
    var plistData: [String: String] = [:] //Our data
    
    
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
    
    
    override init() {
        super.init()
        
        readPropertyList(name: "SipeNope", ext: "plist")
        if plistData != [:]{
            if plistData["datastore"] == "Parse" {
                userInfoDAO = UserInfoImpl()
            }
        }
        
        
    }
    
    
    


}
