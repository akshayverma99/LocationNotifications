//
//  LocationNotificationsTests.swift
//  LocationNotificationsTests
//
//  Created by Akshay Verma on 2019-03-18.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import XCTest
@testable import LocationNotifications

class LocationNotificationsTests: XCTestCase {

    class testCDReminders: ReminderHandler{}
    
    lazy var newReminder = CDReminder(context: testCDReminders.shared.persistentContainer.viewContext)
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        newReminder.locationLatitude = 0
        newReminder.locationLongitude = 0
        newReminder.rangeFromLocation = 50
        newReminder.whenLeaving = true
        newReminder.reminderName = "Test Reminder"
        
        try! testCDReminders.shared.persistentContainer.viewContext.save()
    }
    
    // No longer works because reminders isnt converted to its core data counterpart
//    func testCheckIfReminderExits(){
//        testCDReminders.shared.getRemindersFromData()
//        XCTAssert(testCDReminders.shared.allReminders[0].reminderName == newReminder.reminderName, "Names are diff/doesnt exist")
//    }
   

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testCDReminders.shared.persistentContainer.viewContext.delete(newReminder)
    }

   

}
