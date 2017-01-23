//
//  Alert.swift
//  Sipenope
//
//  Created by Esther Medina on 23/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import UIKit
import Foundation


class Alert: NSObject {
    
    var errorMessage: String!
    var okMessage: String!
    var alertTittle: String!
    var segue: String

    
    init(errorMessage: String, okMessage: String, alertTittle: String, segue: String) {
        self.errorMessage = errorMessage
        self.okMessage = okMessage
        self.alertTittle = alertTittle
        self.segue = segue
    }
    
    
}

