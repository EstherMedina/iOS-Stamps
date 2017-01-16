//
//  MessageInfoDAO.swift
//  Sipenope
//
//  Created by Esther Medina on 11/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//
import Foundation
import UIKit


protocol MessageInfoDAO {
    var plistData: [String:NSObject] {get set}
    
    init(plistData: [String: NSObject])
    
    func setNewMessageInBackground(senderId: String, receiverId: String, message: String)
    
    
    func loadMessages(userId: String, myUserId: String)
}

