//
//  FindFriendsViewController.swift
//  WhereAmI
//
//  Created by Sandeep Palepu on 12/2/15.
//  Copyright © 2015 Sandeep Palepu. All rights reserved.
//

import UIKit
import MapKit


class FindFriendsViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        zoomToRegion()
        
        let annotations = getMapAnnotations()
        
        mapView.addAnnotations(annotations)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    
    func zoomToRegion() {
        
        let location = CLLocationCoordinate2D(latitude: 26.4779991, longitude: -80.0914042)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    func getMapAnnotations() -> [FriendLocationDetail] {
        
      var annotations:Array = [FriendLocationDetail]()
        
      //load plist file
      var userlocDetails: NSArray?
      if let path = NSBundle.mainBundle().pathForResource("userlocDetails", ofType: "plist") {
       userlocDetails = NSArray(contentsOfFile: path)
      }
    
     //iterate and create annotations
     if let items = userlocDetails {
        for item in items {
          let lat = item.valueForKey("lat") as! Double
          let long = item.valueForKey("long")as! Double
          let annotation = FriendLocationDetail(latitude: lat, longitude: long)
          annotation.title = item.valueForKey("name") as? String
          annotations.append(annotation)
        }
      }
    
       return annotations
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ShowFriendsLocation()
    {
        //TODO : Add code to check for Authorized friends before sharing location
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
