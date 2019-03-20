//
//  ReminderInputViewController.swift
//  LocationNotifications
//
//  Created by Akshay Verma on 2019-03-15.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import UserNotifications

enum typeOfReminder{
    case leaving
    case arriving
}

class ReminderInputViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var reminderNameTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var blockerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reminderTypeSwitcher: UISegmentedControl!
    
    var x = 0
    
    var typeOfReminder: ReminderType = .whenArriving
    var selectedLocation: MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminderNameTextField.delegate = self
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
        // If the location has been selected, the map is zoomed in on the selected place and a blue circle is around it
        if let location = selectedLocation, let title = location.name{
            
            locationButton.setTitle(title, for: .normal)
            blockerView.isHidden = true
            mapView.setRegion(MKCoordinateRegion(center: location.placemark.coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
            mapView.addAnnotation(location.placemark)
            let circle = MKCircle(center: location.placemark.coordinate, radius: 50)
            let circleRender = MKCircleRenderer(circle: circle)
            circleRender.fillColor = .blue
            mapView.addOverlay(circle)
            
            
        }
        
        
    }
    
    // MARK: MKMapDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.lineWidth = 1
        circle.strokeColor = .blue
        let color = UIColor(displayP3Red: 0, green: 0, blue: 100, alpha: 0.1)
        circle.fillColor = color
        return circle
    }
    
    
    
    // MARK: IBButtons Pressed
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "location", sender: sender)
    }
    
    @IBAction func reminderSwitcherTapped(_ sender: Any) {
        switch reminderTypeSwitcher.selectedSegmentIndex{
        case 0:
            self.typeOfReminder = .whenArriving
        case 1:
            self.typeOfReminder = .whenLeaving
        default: break
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if selectedLocation == nil{
            
            presentNeedLocationModal()
            
        }else if reminderNameTextField.text?.isEmpty ?? true{
            
            presentNeedAReminderNameModal()
            
        }else{
            // Force unwrapped because if anything was nil, it would have been caught by the if statements above
            let region = CLCircularRegion(center: (selectedLocation?.placemark.coordinate)!, radius: 50, identifier: "\(reminderNameTextField.text!)")
            
            switch typeOfReminder{
                
                case .whenArriving:
                    region.notifyOnEntry = true
                    region.notifyOnExit = false
                case .whenLeaving:
                    region.notifyOnExit = true
                    region.notifyOnEntry = false
                }
            
            let id = UUID()
            let content = UNMutableNotificationContent()
            content.title = "\(reminderNameTextField.text!)"
            let notificationTrigger = UNLocationNotificationTrigger(region: region, repeats: true)
            
            let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: notificationTrigger)
            do{
                let newReminder = Reminder(name: reminderNameTextField.text!, location: (selectedLocation?.placemark.location?.coordinate)!, typeOfReminder: typeOfReminder, uuid: id)
                try ReminderHandler.shared.saveReminder(newReminder)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error{
                        self.presentSaveError(error: error)
                    }
                }
                
               
                self.navigationController?.popViewController(animated: true)
            }catch(let error){
                presentSaveError(error: error)
            }
        }
    }
    
    // MARK: preparing for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newVC = segue.destination as? LocationUpdatingTableViewController{
            newVC.previousVC = self
        }
    }
    
    // MARK: Warning Modals
    
    func presentNeedLocationModal(){
        let newModal = UIAlertController(title: "No Location Specified", message: "Add a location to continue", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        newModal.addAction(okButton)
        present(newModal, animated: false, completion: nil)
    }
    
    func presentNeedAReminderNameModal(){
        let newModal = UIAlertController(title: "No Reminder Name Specified", message: "Add a reminder name to continue", preferredStyle: .alert)
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
    
    // MARK: UITextFieldDelegate
    
    // When the user hits the return button, the keyboard disappears
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
