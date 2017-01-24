//
//  ControllerHelper.swift
//  Sipenope
//
//  Created by Esther Medina on 24/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit

class ControllerHelper {

    //MARK: ACTIVITY INDICATOR
    static func startActivityIndicatorInCentre(view: UIViewController, style: UIActivityIndicatorViewStyle) -> UIActivityIndicatorView {
        let loading = UIActivityIndicatorView(frame: CGRect(x: view.view.center.x, y: view.view.center.y, width: 50, height: 50))
        self.startActivityIndicator(loading: loading, view: view.view, style: style)
        
        return loading
    }
    
    
    static func startActivityIndicator(loading: UIActivityIndicatorView, view: UIView, style: UIActivityIndicatorViewStyle){
        loading.center = view.center
        loading.hidesWhenStopped = true
        loading.activityIndicatorViewStyle = style
        loading.startAnimating()
        view.addSubview(loading)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    static func stopActivityIndicator(loading: UIActivityIndicatorView){
        loading.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    //MARK: ALERTS
    static func sendAlert(title: String, message: String, vc: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: VALIDATE EMAIL
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    
    


}
