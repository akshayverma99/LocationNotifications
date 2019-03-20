//
//  LocationManager.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-05.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation
import CoreLocation

/// Can use a central CLLocationManager instead of creating a new one everytime
class LocationManager{
    static let shared: CLLocationManager = CLLocationManager()
}
