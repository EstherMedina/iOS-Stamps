//
//  RepeInfoDAO.swift
//  Sipenope
//
//  Created by Esther Medina on 8/2/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit


protocol RepeInfoDAO {
    var plistData: [String:NSObject] {get set}
    
    init(plistData: [String: NSObject])
    
    func setNewRepeInBackground(collectionId: String, collectibleId: String, username: String)
    
    func loadRepeFromCollection(username: String, collectionId: String, withFunction theFunction: @escaping ([String : Repe])->())
    
    func loadRepe(username: String, otherCollectibleId: String, withFunction theFunction: @escaping ([String : Repe])->())
    
    func loadRepe(username: String, withFunction theFunction: @escaping ([String : Repe])->())

    func loadRepeAllUsers(withFunction theFunction: @escaping ([String : Repe])->())
    
    

}
