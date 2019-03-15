//
//  Reminder.swift
//  LocationNotifications
//
//  Created by Akshay Verma on 2019-03-13.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation
import MapKit

enum ReminderType{
    case whenLeaving
    case whenArriving
}

struct Reminder{
    var name: String
    var location: CLLocationCoordinate2D
    var rangeFromLocation: Int
    var typeOfReminder: ReminderType
}

