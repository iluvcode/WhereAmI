//
//  LocationDetail+CoreDataProperties.swift
//  WhereAmI
//
//  Created by Sandeep Palepu on 11/28/15.
//  Copyright © 2015 Sandeep Palepu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LocationDetail {

    @NSManaged var name: String?
    @NSManaged var address: String?

}
