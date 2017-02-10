	//
//  ProfileVC.swift
//  Sipenope
//
//  Created by Esther Medina on 23/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController
import CoreLocation

class ProfileVC: UIViewController{
    
    
    @IBOutlet weak var sliderRadius: UISlider!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var swichGender: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var radiusOfInterestLabel: UILabel!
    @IBOutlet weak var location: UILabel!

    var birthDate : Date = Date()
    var loading = UIActivityIndicatorView()
    let userInfoDAO = DAOFactory.sharedInstance.userInfoDAO
    var currentUser : User?
    var locationValue: CLLocationCoordinate2D?
    
    
    //MARK: CHANGE LOCATION
    @IBAction func changeLocation(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToMap", sender: nil)
    }

    //MARK: CHANGE RADIUS
    @IBAction func changeRadius(_ sender: UISlider) {
        radiusOfInterestLabel.text = "\(Int(sender.value))"
    }
    
    //MARK SWITH
    @IBAction func swichChanged(_ sender: Any) {
        if self.swichGender.isOn == true {
            self.gender.text = "Mujer"
        } else {
            self.gender.text = "Hombre"
        }
    }
    
    //MARK PHOTO
    @IBAction func pickPhoto(_ sender: AnyObject) {
        let alerController = UIAlertController(title: "selecciona una imagen", message: "¿De dónde deseas seleccionar la imagen?", preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.loadFromLibrary()
        }
        alerController.addAction(libraryAction)
        
        let cameraAction = UIAlertAction(title: "Cámara de fotos", style: .default) { (action) in
            self.takePhoto()
        }
        alerController.addAction(cameraAction)
        
        let cancelaAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alerController.addAction(cancelaAction)
        
        self.present(alerController, animated: true, completion: nil)
        
    }
    
    //MARK: LOGOUT
    func AuxiliaryLogOut() {
        
        performSegue(withIdentifier: "logout", sender: nil)
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        userInfoDAO?.logOutInBackgroundBlock(withFunction: { () in
            
            self.AuxiliaryLogOut()
            
        })

        
        
    }
    

    //MARK: SAVE
     @IBAction func saveProfile(_ sender: AnyObject) {
        //almaceno los datos en el usuario
        //let userObject = currentUser
        var dict: [String : Any] = [:]
        
        if infoCompleted() {
            dict["email"] = self.emailTextField.text
            dict["username"] = self.emailTextField.text
            
            dict["nickname"] = self.nameTextField.text
            
            if gender.text != "" {
                dict["gender"] = self.swichGender.isOn
            }
            
            if self.radiusOfInterestLabel.text != "" {
                dict["radius"] = Double(self.radiusOfInterestLabel.text!)!
            }
            
            if let image = self.userImageView.image {
                let imageData = UIImageJPEGRepresentation(image, 0.8)! as Data
                if self.userImageView.image != nil {
                    dict["picture"] = imageData
                }
            }
            
            if let loc = self.locationValue {
                dict["location"] = loc
            }
            
            ControllerHelper.startActivityIndicator(loading: loading, view: self.view, style: UIActivityIndicatorViewStyle.whiteLarge)
            self.userInfoDAO?.saveCurrentUserFromFBDict(dict: dict as [String : AnyObject], withFunction: { () in
                
                print("Cambios Almacenados!")
                
            })
            ControllerHelper.stopActivityIndicator(loading: loading)
            
            
        }
     }
    

    

    
    //MARK: GET CURRENT USER
    func AuxiliaryGetCurrentUser(userInfo: [String : User]) {
        
        
        let user = userInfo["user"]
        
        self.currentUser = user

        //nombre
        self.nameTextField.text = self.currentUser?.nickname
        
        //email
        self.emailTextField.text = self.currentUser?.email
        
        //sexo
        if let gender = self.currentUser?.gender {
            if gender == true {
                self.swichGender.isOn = true
                self.gender.text = "Mujer"
            } else {
                self.swichGender.isOn = false
                self.gender.text = "Hombre"
            }
        } else {
            self.gender.text = ""
        }
        
        //imagen
        self.userImageView.image = self.currentUser?.image
        
        //radius
        self.radiusOfInterestLabel.text = "\(Int((self.currentUser?.radius)!))"
        self.sliderRadius.value = Float((self.currentUser?.radius)!)
        
        //location
        if let location = self.currentUser?.location {
            self.locationValue = (location as CLLocationCoordinate2D)
            self.location.text = "   (\(String(format: "%.2f", (self.locationValue?.latitude)!)), \(String(format: "%.2f", (self.locationValue?.longitude)!)))"
        } else {
            self.location.text = " (0.00, 0.00)"
        }
        

        
    }
    
    
    //MARK: DEFAULT
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //metodo que se encarga de saber quien nos ha revelado
        if  revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            //el menu tb se verá con un desplazamiento lateral
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //presentamos todos los datos que tengamos del usuario
        userInfoDAO?.getCurrentUser(withFunction: { (userInfo: [String : User]) in
            self.AuxiliaryGetCurrentUser(userInfo: userInfo )
        })
        
        

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToMap" {
            let map = segue.destination as! MapVC
            map.location = self.locationValue
        }
     }
    
    @IBAction func closeMap(segue: UIStoryboardSegue){
        if let map = segue.source as? MapVC {
            if let loc = map.location {
                self.locationValue = loc
            }
        }
    }

    

    
    
    // MARK: GENERAL
    //comprueba que ambos campos no son vacíos
    func infoCompleted()->Bool {
        var infoCompleted = true
        
        if self.emailTextField.text == "" || self.nameTextField.text == "" {
            infoCompleted = false
            //envio alerta
            //self.sendAlert(title: "Verifica tus datos ", message: "Asegurate de meter Nombre y Correo electrónico correctos")
            ControllerHelper.sendAlert(title: "Verifica tus datos ", message: "Asegurate de meter Nombre y Correo electrónico correctos", vc: self)
        } else {
            //if isValidEmail(email: self.emailTextField.text!) == false {
            if ControllerHelper.isValidEmail(email: self.emailTextField.text!) == false {
                infoCompleted = false
                //envio alerta
                //self.sendAlert(title: "Verifica tus datos ", message: "Asegurate de meter un correo electrónico correcto")
                ControllerHelper.sendAlert(title: "Verifica tus datos ", message:  "Asegurate de meter un correo electrónico correcto", vc: self)
            }
        }
        
        return infoCompleted
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
    
    
extension ProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    func loadFromLibrary() {
        let imagePC = UIImagePickerController()
        imagePC.delegate = self
        imagePC.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePC.allowsEditing = false
        self.present(imagePC, animated: true, completion: nil)
    }
    
    func takePhoto() {
        let imagePC = UIImagePickerController()
        imagePC.delegate = self
        imagePC.sourceType = UIImagePickerControllerSourceType.camera
        imagePC.allowsEditing = false
        self.present(imagePC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //recupero la imagen original
        self.userImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

}

