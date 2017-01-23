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
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    //MARK: DEFAULT
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if userInfoDAO?.isCurrentUserNil() == false || facebookInfoDAO?.isCurrentAccessTokenNil() == false  {
            self.performSegue(withIdentifier: "goToMainVC", sender: nil)
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
            self.performSegue(withIdentifier: "goToMainVC", sender: nil)
        }
     }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: exit
    @IBAction func closeEsther(segue: UIStoryboardSegue){
        if segue.source is FirstViewController {
            print("Vengo de FirstVC!!")
            userInfoDAO?.logOutInBackground()
        }
    }
    
    
    
    
    
    //MARK: LOGIN
    @IBAction func loginPressed(_ sender: AnyObject) {
        if self.infoCompleted()  {
            self.beginActivityIndicator()
            let alert = Alert(errorMessage: "Error de Login. inténtelo de nuevo", okMessage: "Hemos entrado correctamente", alertTittle: "Error de login", segue: "goToMainVC")
            
            NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.AuxiliaryAlertOrSegue), name: NSNotification.Name(rawValue: DAOFactory.notificationNameLogInWithUsername), object: nil)
            userInfoDAO?.logInWithUsername(username: self.username.text!, password: self.password.text!, alert: alert)
    
            
            /*
            PFUser.logInWithUsername(inBackground: self.username.text!, password: self.password.text!, block: { (user, error) in
                self.endActivityIndicator()
                if error != nil {
                    var errorMessage = "Error de Login. inténtelo de nuevo"
                    print(error.debugDescription)
                    if let parseError = (error as! NSError).userInfo["error"] as? String {
                        errorMessage = parseError
                    }
                    self.presentAlert(title: "Error de login", message: errorMessage)
                } else {
                    print("Hemos entrado correctamente")
                    self.performSegue(withIdentifier: "goToMainVC", sender: self)
                }
            })
             */
            
            
            
            
            
        }
    }
    

    //MARK: FACEBOOK
    func AuxiliaryGetFBUserData(notification: NSNotification) {
        if let notificationData = notification.userInfo as? [String : Any] {
            let dict = notificationData["dict"] as! [String : AnyObject]
            
            userInfoDAO?.savePFUserFromFBDict(dict: dict)
        }
    }
    
    
    func getFBUserData()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.AuxiliaryGetFBUserData), name: NSNotification.Name(rawValue: DAOFactory.notificationNameCallFBSDKGraphRequest), object: nil)
        facebookInfoDAO?.callFBSDKGraphRequest()
        
        /*
         FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"]).start(completionHandler: { (connection, result, error) -> Void in
         if (error == nil){
         self.dict = result as! [String : AnyObject]
         print(result!)
         print(self.dict)
         
         
         PFUser.current()!.email = self.dict["email"] as? String
         PFUser.current()!["username"] = PFUser.current()!.email
         PFUser.current()!["gender"] = true
         PFUser.current()!["radius"] = 100
         PFUser.current()!["nickname"] = (self.dict["email"] as? String)?.components(separatedBy: "@")[0]
         //PFUser.current()!["image"]
         let pictureURL = ((self.dict["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"] as! String
         let URLRequest = NSURL(string: pictureURL)
         let URLRequestNeeded = NSURLRequest(url: URLRequest! as URL)
         NSURLConnection.sendAsynchronousRequest(URLRequestNeeded as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) in
         
         if error == nil {
         let imageData = UIImageJPEGRepresentation(UIImage(data:data!)!, 0.8)
         let imageFile = PFFile(name: "image.jpg", data: imageData!)
         
         PFUser.current()!["image"] = imageFile
         
         }
         PFUser.current()!.saveInBackground()
         })
         }
         })
         */
    }

    func AuxiliaryLoginFacebook(notification: NSNotification) {
        if let notificationData = notification.userInfo as? [String : Any] {
            let error = notificationData["error"] as? Error
            let user = notificationData["user"] as Any
            
            if error == nil {
                if  (userInfoDAO?.isUserNew(user: user))! {
                    print("User signed up and logged in with Facebook! \(user)")
                    self.getFBUserData()
                    
                    self.performSegue(withIdentifier: "goToMainVC", sender: nil)
                } else {
                    print("User logged in via Facebook \(user)")
                    self.performSegue(withIdentifier: "goToMainVC", sender: nil)
                }
            }
        }
        self.endActivityIndicator()
    }
    
    @IBAction func facebookPressed(_ sender: AnyObject) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.AuxiliaryLoginFacebook), name: NSNotification.Name(rawValue: DAOFactory.notificationNameLogInBackground), object: nil)
        self.beginActivityIndicator()
        facebookInfoDAO?.logInInBackground(withReadPermissions: [])
        
        
        /*
        PFFacebookUtils.logInInBackground(withReadPermissions: []) { (user, error) in
            if error != nil {
                //process error
                print(error.debugDescription)
                return
            }
            else
            {
                
                if user!.isNew {
                    print("User signed up and logged in with Facebook! \(user)")
                    self.getFBUserData()
                    
                    self.performSegue(withIdentifier: "goToMainVC", sender: nil)
                } else {
                    print("User logged in via Facebook \(user)")
                    self.performSegue(withIdentifier: "goToMainVC", sender: nil)
                }
                
            }
        }
         */
    }
    
    
    
    
    
    
    //MARK: forgotPasswordPressed
    func AuxiliaryForgotPasswordPressed(notification: NSNotification) {
        if let notificationData = notification.userInfo as? [String : Any] {
            let error = notificationData["error"] as? Error
            let email = notificationData["email"] as! String
            
            
            self.AuxiliaryAlertOrSegue(notification: notification)
            
            if error == nil {
                //crear otra alerta
                self.presentAlert(title: "Contraseña recuperada", message: "Mira tu bandeja de entrada de \(email) y sigue las instrucciones indicadas")
            }
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
            
            self.beginActivityIndicator()
            NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.AuxiliaryForgotPasswordPressed), name: NSNotification.Name(rawValue: DAOFactory.notificationNameRequestPasswordResetForEmail), object: nil)
            self.userInfoDAO?.requestPasswordResetForEmail(email: theEmailTextfield.text!, alert: alert)
            
            /*PFUser.requestPasswordResetForEmail(inBackground: theEmailTextfield.text!, block: { (success, error) in
                if error != nil {
                    var errorMessage = "Error al crear al recuperar la contraseña. inténtelo de nuevo"
                    print(error.debugDescription)
                    if let parseError = (error as! NSError).userInfo["error"] as? String {
                        errorMessage = parseError
                    }
                    self.presentAlert(title: "Error de contraseña", message: errorMessage)
                } else {
                    //crear otra alerta
                    self.presentAlert(title: "Contraseña recuperada", message: "Mira tu bandeja de entrada de \(theEmailTextfield.text!) y sigue las instrucciones indicadas")
                }
            })
             */
             
        }
        let cancelAction = UIAlertAction(title: "Ahora no", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:signUp
    @IBAction func signUpPressed(_ sender: AnyObject) {
        if self.infoCompleted()  {
            self.createNewUser()
        }
        
    }

    
    //MARK: createNewUser
    func createNewUser() {
        let alert = Alert(errorMessage: "Error al crear el nuevo cliente. inténtelo de nuevo", okMessage: "Usuario registrado correctamente", alertTittle: "Error de registro", segue: "goToMainVC")
        self.beginActivityIndicator()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.AuxiliaryAlertOrSegue), name: NSNotification.Name(rawValue: DAOFactory.notificationNameCreateNewUser), object: nil)
        self.userInfoDAO?.createNewUser(username: self.username.text!, email: self.username.text!, password: self.password.text!, alert: alert)
        
        /*
        let user = PFUser()
        user.username = self.username.text
        user.email = self.username.text
        user.password = self.password.text
        user.signUpInBackground { (success, error) in
            if error != nil {
                var errorMessage = "Error al crear el nuevo cliente. inténtelo de nuevo"
                print(error.debugDescription)
                if let parseError = (error as! NSError).userInfo["error"] as? String {
                    errorMessage = parseError
                }
                self.presentAlert(title: "Error de registro", message: errorMessage)
            } else {
                print("Usuario registrado correctamente")
                
                //Transiciono a la siguietne pantalla
                self.performSegue(withIdentifier: "goToMainVC", sender: self)
            }
        }
         */
    }
    

    
    //MARK: GENERAL
    func AuxiliaryAlertOrSegue(notification: NSNotification) {
        if let notificationData = notification.userInfo as? [String : Any] {
            let error = notificationData["error"] as? Error
            let alert = notificationData["alert"] as! Alert
            
            if error != nil {
                var errorMessage = alert.errorMessage
                print(error?.localizedDescription ?? "Error")
                if let parseError = (error as! NSError).userInfo["error"] as? String {
                    errorMessage = parseError
                }
                self.presentAlert(title: alert.alertTittle, message: errorMessage!)
            } else {
                print(alert.okMessage)
                
                //Transiciono a la siguietne pantalla
                if alert.segue != "" {
                    self.performSegue(withIdentifier: alert.segue, sender: self)
                }
            }
        }
        self.endActivityIndicator()
    }
    

    func beginActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 50, height: 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        //no hagas caso a ningún botón más hasta que te lo indique
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func endActivityIndicator() {
        self.activityIndicator.stopAnimating()
        //no hagas caso a ningún botón más hasta que te lo indique
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    //comprueba que ambos campos no son vacíos
    func infoCompleted()->Bool {
        var infoCompleted = true
        
        if self.username.text == "" || self.password.text == "" {
            infoCompleted = false
            //envio alerta
            self.presentAlert(title: "Verifica tus datos ", message: "Asegurate de meter usr y contraseña correctos")
        }
        
        return infoCompleted
    }
    
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}


extension LoginVC: UITextFieldDelegate {
    //cuando se pulse enter en los textfields va a ocultar el teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
