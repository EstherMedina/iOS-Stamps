//
//  LoginVC.swift
//  Sipenope
//
//  Created by Esther Medina on 11/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit



class LoginVC: UIViewController  {
    
    var dict : [String : AnyObject]!
    var activityIndicator : UIActivityIndicatorView!
    let userInfoDAO = DAOFactory.sharedInstance.userInfoDAO
    let facebookInfoDAO  = DAOFactory.sharedInstance.facebookInfoDAO
    //let GoToNextView = "goToMainVC"
    let GoToNextView = "GoToSWRevealViewController"
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    //MARK: DEFAULT
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if userInfoDAO?.isCurrentUserNil() == false || facebookInfoDAO?.isCurrentAccessTokenNil() == false  {
            self.performSegue(withIdentifier: self.GoToNextView, sender: nil)
        }
       
        
        //cuando se hace un  logout, se queda la barra de navegación, por lo q ocultarla
        self.navigationController?.navigationBar.isHidden = true
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        
        if (facebookInfoDAO?.isCurrentAccessTokenNil() == false)
        {
            // User is already logged in, do work such as go to next view controller.
            print("Hemos entrado correctamente con facebook")
            self.performSegue(withIdentifier: self.GoToNextView, sender: nil)
        }
        
        
        //Carga de cromos
        //ReadCSVFiles.loadCollectablesFromCSV()
         
        
     }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: EXIT
    @IBAction func closeEsther(segue: UIStoryboardSegue){
        if segue.source is FirstViewController {
            print("Vengo de FirstVC!!")
            userInfoDAO?.logOutInBackground()
        }
    }
    
    
    
    
    
    //MARK: LOGIN
    @IBAction func loginPressed(_ sender: AnyObject) {
        if self.infoCompleted()  {
            //self.beginActivityIndicator()
            self.activityIndicator = ControllerHelper.startActivityIndicatorInCentre(view: self, style: UIActivityIndicatorViewStyle.gray)
            let alert = Alert(errorMessage: "Error de Login. inténtelo de nuevo", okMessage: "Hemos entrado correctamente", alertTittle: "Error de login", segue: self.GoToNextView)

            userInfoDAO?.logInWithUsername(username: self.username.text!, password: self.password.text!, alert: alert, withFunction: { (userInfo: [String : Any]) in
                
                self.AuxiliaryAlertOrSegue(userInfo: userInfo)
                
            })
            
            
        }
    }
    

    //MARK: FACEBOOK
    func AuxiliaryGoToMainVC() {
        self.performSegue(withIdentifier: self.GoToNextView, sender: nil)
    }

    func AuxiliaryGetFBUserData(userInfo: [String : AnyObject]) {

            let dict = userInfo["dict"] as! [String : AnyObject]
        
            userInfoDAO?.saveCurrentUserFromFBDict(dict: dict, withFunction: { () in
            
                self.AuxiliaryGoToMainVC()
            
            })
        
            
        
    }
    
    
    func getFBUserData()
    {
        
        facebookInfoDAO?.callFBSDKGraphRequest(withFunction: { (userInfo: [String : Any]) in
            
            self.AuxiliaryGetFBUserData(userInfo: userInfo as [String : AnyObject])
            
        })


    }

    func AuxiliaryLoginFacebook(userInfo: [String : Any]) {
        let error = userInfo["error"] as? Error
        let user = userInfo["user"] as Any
        
        if self.userInfoDAO?.isUserNil(user: user) == false  {
            if error == nil {
                if  (self.userInfoDAO?.isUserNew(user: user))! {
                    print("User signed up and logged in with Facebook! \(user)")
                    self.getFBUserData()
                    
                    
                } else {
                    print("User logged in via Facebook \(user)")
                    self.performSegue(withIdentifier: self.GoToNextView, sender: nil)
                }
            }
        }

        ControllerHelper.stopActivityIndicator(loading: self.activityIndicator)
    }
    
    @IBAction func facebookPressed(_ sender: AnyObject) {

        //self.beginActivityIndicator()
        self.activityIndicator = ControllerHelper.startActivityIndicatorInCentre(view: self, style: UIActivityIndicatorViewStyle.gray)
        facebookInfoDAO?.logInInBackground(withReadPermissions: [], withFunction: { (userInfo: [String : Any]) in
            
            self.AuxiliaryLoginFacebook(userInfo: userInfo)
            
        })
        
    }
    
    
    
    
    
    
    //MARK: FORGOT PASSWORD
    func AuxiliaryForgotPasswordPressed(userInfo: [String : Any]) {

        let error = userInfo["error"] as? Error
        let email = userInfo["email"] as! String
        
        
        self.AuxiliaryAlertOrSegue(userInfo: userInfo)
        
        if error == nil {
            //crear otra alerta
            ControllerHelper.sendAlert(title: "Contraseña recuperada", message: "Mira tu bandeja de entrada de \(email) y sigue las instrucciones indicadas", vc: self)
        }
        
    }
    
    
    @IBAction func forgotPasswordPressed(_ sender: AnyObject) {
        //crear un alert controller con caja de text
        let alertController = UIAlertController(title: "Recuperar contraseña", message: "Introduce el email de registro en Sipe Nope", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Introduce aquí tu email"
        }
        let okAction = UIAlertAction(title: "Recuperar contraseña", style: .default) { (action) in
            let theEmailTextfield = alertController.textFields![0] as UITextField
            let alert = Alert(errorMessage: "Error al crear al recuperar la contraseña. inténtelo de nuevo", okMessage: "Contraseña recuperada", alertTittle: "Error de contraseña", segue: "")
            
            if ControllerHelper.isValidEmail(email: theEmailTextfield.text!) == false {
                ControllerHelper.sendAlert(title: "Verifica tus datos ", message:  "Asegurate de meter un correo electrónico correcto", vc: self)
            } else {
                self.activityIndicator = ControllerHelper.startActivityIndicatorInCentre(view: self, style: UIActivityIndicatorViewStyle.gray)
                
                self.userInfoDAO?.requestPasswordResetForEmail(email: theEmailTextfield.text!, alert: alert, withFunction: { (userInfo: [String : Any]) in
                    
                    self.AuxiliaryForgotPasswordPressed(userInfo: userInfo)
                    
                    
                })

                

            }
            
        }
        let cancelAction = UIAlertAction(title: "Ahora no", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:SIGNUP - create new user
    @IBAction func signUpPressed(_ sender: AnyObject) {
        if self.infoCompleted()  {
            self.createNewUser()
        }
        
    }

    func createNewUser() {
        if self.infoCompleted() {
            if ControllerHelper.isValidEmail(email: self.username.text!) == false {
                ControllerHelper.sendAlert(title: "Verifica tus datos ", message:  "Asegurate de meter un correo electrónico correcto", vc: self)
            } else {
                let alert = Alert(errorMessage: "Error al crear el nuevo cliente. inténtelo de nuevo", okMessage: "Usuario registrado correctamente", alertTittle: "Error de registro", segue: self.GoToNextView)
                self.activityIndicator = ControllerHelper.startActivityIndicatorInCentre(view: self, style: UIActivityIndicatorViewStyle.gray)
                self.userInfoDAO?.createNewUser(username: self.username.text!, email: self.username.text!, password: self.password.text!, alert: alert, withFunction: { (userInfo: [String : Any]) in
                    
                    self.AuxiliaryAlertOrSegue(userInfo: userInfo)
                
                })
        
            }
        }
    }
    

    
    //MARK: GENERAL
    func AuxiliaryAlertOrSegue(userInfo: [String : Any]) {
        let error = userInfo["error"] as? Error
        let alert = userInfo["alert"] as! Alert
       
        if error != nil  {
            var errorMessage = alert.errorMessage
            print(error!.localizedDescription)
            if let parseError = (error as! NSError).userInfo["error"] as? String {
                errorMessage = parseError
            }
            //self.presentAlert(title: alert.alertTittle, message: errorMessage!)
            ControllerHelper.sendAlert(title: alert.alertTittle, message: errorMessage!, vc: self)
        } else {
            print(alert.okMessage)
            
            //Transiciono a la siguietne pantalla
            if alert.segue != "" {
                self.performSegue(withIdentifier: alert.segue, sender: self)
            }
        }
        
        //self.endActivityIndicator()
        ControllerHelper.stopActivityIndicator(loading: self.activityIndicator)
        
    }
    
    
    //comprueba que ambos campos no son vacíos
    func infoCompleted()->Bool {
        var infoCompleted = true
        
        if self.username.text == "" || self.password.text == "" {
            infoCompleted = false
            //envio alerta
            //self.presentAlert(title: "Verifica tus datos ", message: "Asegurate de meter usr y contraseña correctos")
            ControllerHelper.sendAlert(title: "Verifica tus datos ", message: "Asegurate de meter usr y contraseña correctos", vc: self)
        }
        
        return infoCompleted
    }
    

}


extension LoginVC: UITextFieldDelegate {
    //cuando se pulse enter en los textfields va a ocultar el teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
