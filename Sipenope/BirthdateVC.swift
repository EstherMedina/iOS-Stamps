//
//  BirthdateVC.swift
//  Sipenope
//
//  Created by Esther Medina on 23/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit

class BirthdateVC: UIViewController {
    
    
    var defaultDate = Date()
    
    @IBOutlet weak var birthdatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdatePicker.setDate(self.defaultDate, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

