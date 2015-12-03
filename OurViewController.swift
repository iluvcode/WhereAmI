//
//  OurViewController.swift
//  WhereAmI
//
//  Created by Sandeep Palepu on 11/27/15.
//  Copyright © 2015 Sandeep Palepu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class OurViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var locationDetails = [NSManagedObject]()
    
    var coreLocationManager = CLLocationManager()
    
    var locationManager:LocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var userCurrentLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        coreLocationManager.delegate = self
        
        locationManager = LocationManager.sharedInstance
        
        let authorizationCode = CLLocationManager.authorizationStatus()
        
        if authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManager.respondsToSelector("requestAlwaysAuthorization") || coreLocationManager.respondsToSelector("requestWhenInUseAuthorization"){
            if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil{
                coreLocationManager.requestAlwaysAuthorization()
            }else{
                print("No description provided")
            }
        }else{
            getLocation()
        }
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            getLocation()
            
        }

    }
    
    func getLocation(){
        
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            
            self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
        }
        
        
    }
    
    func displayLocation(location:CLLocation){
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude
            , location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        
        
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil && placemarks!.count > 0 {
                let loc = placemarks![0] as CLPlacemark
                
                
                if loc.subThoroughfare != nil{
                    self.userCurrentLocation = "\(loc.subThoroughfare!)"
                }
                
                if loc.thoroughfare != nil{
                    self.userCurrentLocation = "\(self.userCurrentLocation) \(loc.thoroughfare!)"
                }
                
                if loc.subLocality != nil{
                    self.userCurrentLocation = "\(self.userCurrentLocation) \(loc.subLocality!)"
                }
                
                if loc.locality != nil{
                    self.userCurrentLocation = "\(self.userCurrentLocation) \(loc.locality!)"
                }
                
                if loc.administrativeArea != nil{
                    self.userCurrentLocation = "\(self.userCurrentLocation) \(loc.administrativeArea!)"
                }
                
                if loc.postalCode != nil{
                    self.userCurrentLocation = "\(self.userCurrentLocation) \(loc.postalCode!)"
                }
                
                //self.locationInfo.text = userCurrentLocation
                
                annotation.title = "your current location"
                annotation.subtitle = self.userCurrentLocation
                self.mapView.addAnnotation(annotation)
                
                self.mapView.showAnnotations([annotation], animated: true)
                
            }
        })
        
       
      
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted{
            getLocation()
            
        }
    }
    
    @IBAction func updateLocation(sender: AnyObject) {
        getLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveLocation(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Location Name",
            message: nil,
            preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler {
            (tf:UITextField) in
            tf.keyboardType = .NumberPad
            tf.addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)
        }
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                    self.saveName(textField!.text!)
                
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
//        alert.addTextFieldWithConfigurationHandler {
//            (textField: UITextField) -> Void in
//        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        //Disable save button , activate it when there is a text changed
        alert.actions[0].enabled = false
        
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
    
    func textChanged(sender:AnyObject) {
        let tf = sender as! UITextField
        // enable Save button only if there is text
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.nextResponder() }
        let alert = resp as! UIAlertController
        alert.actions[0].enabled = (tf.text != "")
    }
    
    func saveName(name: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("LocationDetail",
            inManagedObjectContext:managedContext)
        
        let locName = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        locName.setValue(name, forKey: "name")
        locName.setValue(self.userCurrentLocation, forKey: "address")
        
        //4
        do {
            try managedContext.save()
            //5
            locationDetails.append(locName)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
   

}
