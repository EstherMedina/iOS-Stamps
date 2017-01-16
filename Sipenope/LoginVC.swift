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
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import ParseFacebookUtilsV4

class LoginVC: UIViewController , FBSDKLoginButtonDelegate {
    
    //MARK: FACEBOOK
    
    
    var activityIndicator : UIActivityIndicatorView!
    
    // Facebook Delegate Methods
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        if ((error) != nil)
        {
            // Process error
            print("Hay error en log de Facebook: \(error.localizedDescription)")
            return
        }
        else if result.isCancelled {
            // Handle cancellations
            print("Cancelled")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
        print("Do work")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"]).start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                //let userName : NSString = result.valueForKey("name") as! NSString
                //print("User Name is: \(userName)")
                //let userEmail : NSString = result.valueForKey("email") as! NSString
                //print("User Email is: \(userEmail)")
            }
        })
    }
    
    
    
    
    
    //MARK: ACTIONS&OUTLETS
    
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        if self.infoCompleted()  {
            self.beginActivityIndicator()
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
            
            
            
            
            
        }
    }
    
    @IBAction func facebookPressed(_ sender: AnyObject) {
        
        
        let permissions = ["public_profile", "email", "user_friends"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
        
        /*
         if FBSDKAccessToken.current() != nil {
         FBSDKLoginManager().logOut()
         return
         }
         
         let login: FBSDKLoginManager = FBSDKLoginManager()
         login.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
         if error != nil {
         FBSDKLoginManager().logOut()
         } else if (result?.isCancelled)! {
         FBSDKLoginManager().logOut()
         } else {
         print("exito!!!")
         }
         }*/
        
        
    }
    
    @IBAction func forgotPasswordPressed(_ sender: AnyObject) {
        //crear un alert controller con caja de text
        let alertController = UIAlertController(title: "Recuperar contraseña", message: "Introduce el email de registro en Sipe Nope", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Introduce aquí tu email"
        }
        let okAction = UIAlertAction(title: "Recuperar contraseña", style: .default) { (action) in
            let theEmailTextfield = alertController.textFields![0] as UITextField
            
            
            PFUser.requestPasswordResetForEmail(inBackground: theEmailTextfield.text!, block: { (success, error) in
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
             
        }
        let cancelAction = UIAlertAction(title: "Ahora no", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: AnyObject) {
        if self.infoCompleted()  {
            self.beginActivityIndicator()
            // en appdelegate comento: //PFUser.enableAutomaticUser()
            self.createNewUserUser()
            self.endActivityIndicator()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "goToMainVC", sender: nil)
        }
        
        //cuando se hace un  logout, se queda la barra de navegación, por lo q ocultarla
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    
    
    //MARK: DEFAULT
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Descomenta esta linea para probar que Parse funciona correctamente
        //self.testParseSave()
        
        //self.createUsers()
        //self.getObjetc(nameClass: "Users", id: "e0oOnJ87y7")
        
        
        
        
        if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("Hemos entrado correctamente con facebook")
            self.performSegue(withIdentifier: "goToMainVC", sender: nil)
        }
        else
        {
            
            facebookButton.delegate = self
            facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
            
            /* let loginView : FBSDKLoginButton = FBSDKLoginButton()
             self.view.addSubview(loginView)
             loginView.center = self.view.center
             loginView.readPermissions = ["public_profile", "email", "user_friends"]
             loginView.delegate = self
             
             //self.password.isHidden = true
             print("******************************")
             print(self.password.center)
             print(self.view.center)*/
            
            
            
        }
        
        /*
         let gameScore = PFObject(className:"score")
         gameScore["level"] = 1337
         gameScore.pinInBackground(withName: "score")
         //gameScore.unpinInBackground(withName: "score")
         //PFObject.unpinAllObjectsInBackground(withName: "score")
         gameScore.saveInBackground()
         */
        
        
        
        /*let query2 = PFQuery(className:"GameScore")
         query2.fromPin(withName: "MyChanges")
         query2.findObjectsInBackground().continue({
         (task: BFTask!) -> AnyObject! in
         let scores = task.result! as NSArray
         for score in scores {
         (score as AnyObject).saveInBackground().continue(successBlock: {
         (task: BFTask!) -> AnyObject! in
         return (score as AnyObject).unpinInBackground()
         })
         }
         return task
         })*/
        
        
        
        
        /*
         var query = PFQuery(className:"score")
         query.fromLocalDatastore()
         query.whereKey("level", equalTo: 1337)
         query.findObjectsInBackground {
         (objects: [PFObject]?, error: Error?) -> Void in
         
         if error == nil {
         // The find succeeded.
         print("Successfully retrieved \(objects!.count) scores.")
         // Do something with the found objects
         if let objects = objects {
         for object in objects {
         print(object["level"] as! Int)
         //object.unpinInBackground()
         }
         }
         } else {
         // Log details of the failure
         print("Error: \(error!) \((error! as! NSError).userInfo)")
         }
         }*/
        
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK: PARSE
    func getObjetc(nameClass: String, id: String) {
        let query = PFQuery(className: nameClass)
        query.getObjectInBackground(withId: id) { (object, error) in
            if error != nil {
                print (error?.localizedDescription)
            } else {
                if let user = object {
                    print(user)
                    //cambio algún valor
                    user["name"] = "Esther"
                    user.saveInBackground(block: { (success, error) in
                        if success {
                            print("El objeto se ha modificado.")
                        } else {
                            print ("Error")
                        }
                    })
                }
            }
            
        }
    }
    
    func testParseSave() {
        let testObject = PFObject(className: "MyTestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackground { (success, error) -> Void in
            if success {
                print("El objeto se ha guardado en Parse correctamente.")
            } else {
                if error != nil {
                    print (error)
                } else {
                    print ("Error")
                }
            }
        }
    }
    
    func createUsers() {
        let testObject = PFObject(className: "Users")
        testObject["name"] = "Juan"
        testObject.saveInBackground { (success, error) -> Void in
            if success {
                print("El usuario se ha guardado en Parse correctamente.")
            } else {
                if error != nil {
                    print (error)
                } else {
                    print ("Error")
                }
            }
        }
    }
    
    func createNewUserUser() {
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
    }
    
    
    //MARK: GENERAL
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
