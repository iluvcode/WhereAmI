//
//  OurViewController2.swift
//  WhereAmI
//
//  Created by Sandeep Palepu on 11/27/15.
//  Copyright © 2015 Sandeep Palepu. All rights reserved.
//

import UIKit
import CoreData

class OurViewController2: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var locationDetails = [NSManagedObject]()
    
    var deleteLocationIndexPath: NSIndexPath? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        tableView.registerClass(LocationInfoTableViewCell.self,
//            forCellReuseIdentifier: "cell")

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "LocationDetail")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            locationDetails = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationDetails.count
    }

   override func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! LocationInfoTableViewCell
            
            let userloc = locationDetails[indexPath.row]
            
            let savedLocationname = userloc.valueForKey("name") as? String
            let savedLocationAddress = userloc.valueForKey("address") as? String
            
            //cell!.textLabel!.text = savedLocationname! + " " + savedLocationAddress!
            
            if savedLocationname != nil{
                cell.locationNameLabel.text = savedLocationname!
                cell.addressLabel.text = savedLocationAddress!
            }
            else
            {
                cell.locationNameLabel.text = "No Locations Saved !"
                cell.addressLabel.text = ""
            }
            
            
            
            return cell
    }
    
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteLocationIndexPath = indexPath
            let planetToDelete = locationDetails[indexPath.row]
            confirmDelete(planetToDelete)
        }
    }
    
    func confirmDelete(loc: NSManagedObject) {
        let deletelocationName = loc.valueForKey("name") as? String
        
        let alert = UIAlertController(title: "Delete location", message: "Are you sure you want to permanently delete \(deletelocationName!)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteLocation)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteLocation)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        //alert.popoverPresentationController?.sourceView = self.view
        //alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteLocation(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteLocationIndexPath {
            
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject(locationDetails[indexPath.row] as NSManagedObject)
            locationDetails.removeAtIndex(indexPath.row)
            do{
                try context.save()
            }catch{
                print("Error, data not saved!")
            }
            
            //tableView.reloadData()
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            deleteLocationIndexPath = nil
           
        }
    }
    
    func cancelDeleteLocation(alertAction: UIAlertAction!) {
        deleteLocationIndexPath = nil
    }
}
