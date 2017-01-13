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
    
    func newConnection(applicationId: String, clientKey: String, server: String, isLocalDatastoreEnabled: Bool) {
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = applicationId
            ParseMutableClientConfiguration.clientKey = clientKey
            ParseMutableClientConfiguration.server = server
            ParseMutableClientConfiguration.isLocalDatastoreEnabled = isLocalDatastoreEnabled
        })
        Parse.enableLocalDatastore()
        Parse.initialize(with: parseConfiguration)

    }
}
