//
//  FriendLocationDetail.swift
//  WhereAmI
//
//  Created by Sandeep Palepu on 12/2/15.
//  Copyright © 2015 Sandeep Palepu. All rights reserved.
//

import UIKit
import MapKit

class FriendLocationDetail: NSObject,MKAnnotation {

    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
