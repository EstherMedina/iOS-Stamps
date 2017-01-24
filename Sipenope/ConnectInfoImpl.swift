//
//  ConnectInfoImpl.swift
//  Sipenope
//
//  Created by Esther Medina on 13/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//


import Foundation
import UIKit
import Parse


class ConnectInfoImpl: ConnectInfoDAO {
    
    var plistData: [String:NSObject] = [:]
    var applicationId: String = ""
    var clientKey: String = ""
    var server: String = ""
    var isLocalDatastoreEnabled: Bool = true
    
    
    required init(plistData: [String: NSObject]) {
        self.plistData = plistData
        self.applicationId = self.plistData["applicationId"]! as! String
        self.clientKey = self.plistData["clientKey"]! as! String
        self.server = self.plistData["server"]! as! String
        self.isLocalDatastoreEnabled = self.plistData["isLocalDatastoreEnabled"]! as! Bool
    }
    
    
    //MARK: NEW CONNECTION
    func newConnection() {
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = self.applicationId
            ParseMutableClientConfiguration.clientKey = self.clientKey
            ParseMutableClientConfiguration.server = self.server
            ParseMutableClientConfiguration.isLocalDatastoreEnabled = self.isLocalDatastoreEnabled
        })
        Parse.enableLocalDatastore()
        Parse.initialize(with: parseConfiguration)

    }
}
