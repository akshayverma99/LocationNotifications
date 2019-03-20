//
//  ReminderHandler.swift
//  LocationNotifications
//
//  Created by Akshay Verma on 2019-03-15.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation
import CoreData

public class ReminderHandler{
    
    static let shared: ReminderHandler = ReminderHandler()
    
    
    lazy var persistentContainer: NSPersistentContainer = {
  
        let container = NSPersistentContainer(name: "LocationNotifications")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // App wont work without the persistance container
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Takes a reminder a converts it into its core data counterpart
    func saveReminder(_ reminder: Reminder) throws{
        let newReminder = CDReminder(context: self.persistentContainer.viewContext)
        newReminder.reminderName = reminder.name
        newReminder.locationLatitude = reminder.location.latitude
        newReminder.locationLongitude = reminder.location.longitude
        newReminder.uuid = reminder.uuid
        newReminder.dateCreated = Date()
        if reminder.typeOfReminder == .whenArriving{
            newReminder.whenLeaving = false
        }else{
            newReminder.whenLeaving = true
        }
        
        try ReminderHandler.shared.persistentContainer.viewContext.save()
    }

    
}
