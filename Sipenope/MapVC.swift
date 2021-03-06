//
//  MapVC.swift
//  Sipenope
//
//  Created by Esther Medina on 25/1/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var location: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()

    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        self.mark(degrees: 0.5)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.action))
        lpgr.minimumPressDuration = 2
        map.addGestureRecognizer(lpgr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        self.mark(degrees: 0.05)
    }

    

    
    //MARG: GENERAL
    
    
    
    
    func action(gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.map)
        let newCoordinate:CLLocationCoordinate2D = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        //añadir al mapa una chincheta
        let annotation = MKPointAnnotation()
        //donde esta la chihceta
        annotation.coordinate = newCoordinate
        annotation.title = "Localización nueva"
        annotation.subtitle = "   (\(String(format: "%.2f", (newCoordinate.latitude))), \(String(format: "%.2f", (newCoordinate.longitude))))"
        map.removeAnnotations(map.annotations)
        map.addAnnotation(annotation)
        
        self.location?.latitude = newCoordinate.latitude
        self.location?.longitude = newCoordinate.longitude
        
        
    }


    
    func mark(degrees: Double) {
        //usar lo siguiente como zoom/apertura
        let latDelta:CLLocationDegrees = degrees //cuantos grados quiero ver en mi mapa
        let lonDelta:CLLocationDegrees = degrees
        //asociarlo al zoom
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta,lonDelta)
        
        if CLLocationCoordinate2DIsValid(self.location!) {
            //asociarlo a la posicoópn y la apertura
            let region: MKCoordinateRegion = MKCoordinateRegionMake(self.location!, span)
            map.setRegion(region, animated: true)
        }

        
        
        //chincheta
        let annotation = MKPointAnnotation()
        annotation.title = "Mi localización"
        //annotation.subtitle = self.user?.email
        annotation.coordinate = (self.location)!
        self.map.showAnnotations([annotation], animated: true)
        self.map.selectAnnotation(annotation, animated: true)

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

