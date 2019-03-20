//
//  RemindersTableViewController.swift
//  LocationNotifications
//
//  Created by Akshay Verma on 2019-03-13.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation

class RemindersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    // Handles all the data changes to reminders
    let fetchController: NSFetchedResultsController<CDReminder> = {
        let fetchReq = NSFetchRequest<CDReminder>(entityName: "Reminder")
        fetchReq.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
        let placeHolder = NSFetchedResultsController(fetchRequest: fetchReq, managedObjectContext: ReminderHandler.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return placeHolder
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // Asks the user to enable location services
            if CLLocationManager.locationServicesEnabled(){
                LocationManager.shared.requestAlwaysAuthorization()
                LocationManager.shared.startUpdatingLocation()
            }else{
                self.locationNotEnabledModal()
            }

        
        do{
            try fetchController.performFetch()
        }catch{
            unableToRetrieveReminders()
        }
        
        fetchController.delegate = self
    }
    
    // If a new reminder is added, the table view is reloaded, if a reminder is deleted it is handled by the deletion method below
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert{
            tableView.reloadData()
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.fetchedObjects?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ReminderTableViewCell
        
        // Configure the cell...
        if let reminders = fetchController.fetchedObjects{
            let reminder = reminders[indexPath.row]
            
            cell.titleOfReminder.text = reminder.reminderName
            
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let reminders = fetchController.fetchedObjects{
      
                do{
                    // The UUID is non-optional and must exist so it is force-unwrapped
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(reminders[indexPath.row].uuid!.uuidString)"])
                    ReminderHandler.shared.persistentContainer.viewContext.delete(reminders[indexPath.row])
                    try ReminderHandler.shared.persistentContainer.viewContext.save()
                }catch let error{
                    presentSaveError(error: error)
                }
                
            }
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }

    
    // MARK: Error Modals
    
    func locationNotEnabledModal(){
        let newModal = UIAlertController(title: "Location Disabled", message: "Turn on location for the app to work", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        newModal.addAction(okButton)
        present(newModal, animated: false, completion: nil)
    }
    
    func remindersNotEnabled(){
        let newModal = UIAlertController(title: "Reminders Disabled", message: "Turn on reminders for the app to work", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        newModal.addAction(okButton)
        present(newModal, animated: false, completion: nil)
    }
    
    func unableToRetrieveReminders(){
        let newModal = UIAlertController(title: "Retrival Failure", message: "Unable to retrieve previous reminders", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        newModal.addAction(okButton)
        present(newModal, animated: false, completion: nil)
    }
    
    func presentSaveError(error: Error){
        let newModal = UIAlertController(title: "Failure to save", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        newModal.addAction(okButton)
        present(newModal, animated: false, completion: nil)
    }
    
}
