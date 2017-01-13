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

    func newConnection(applicationId: String, clientKey: String, server: String, isLocalDatastoreEnabled: Bool)
}

