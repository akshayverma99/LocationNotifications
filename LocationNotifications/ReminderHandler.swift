//
//  ReminderHandler.swift
//  LocationNotifications
//
//  Created by Akshay Verma on 2019-03-15.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation
import CoreData

class ReminderHandler{
    
    static let shared: ReminderHandler = ReminderHandler()
    
    let allReminders: [Reminder] = []
    
    lazy var persistentContainer: NSPersistentContainer = {
  
        let container = NSPersistentContainer(name: "LocationNotifications")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
                
            }
        })
        return container
    }()
    
    
}
