//
//  ConnectInfoDAO.swift
//  Sipenope
//
//  Created by Esther Medina on 13/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit


protocol ConnectInfoDAO {
    var plistData: [String:NSObject] {get set}
    var applicationId: String {get set}
    var clientKey: String {get set}
    var server: String {get set}
    var isLocalDatastoreEnabled: Bool {get set}
    
    init(plistData: [String: NSObject])

    func newConnection()
}

