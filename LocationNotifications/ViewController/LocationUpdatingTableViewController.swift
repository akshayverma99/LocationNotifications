//
//  LocationUpdatingTableViewController.swift
//  LocationNotifications
//
//  Created by Akshay Verma on 2019-03-15.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit
import MapKit

class LocationUpdatingTableViewController: UITableViewController, UISearchControllerDelegate{

    let searchCompleter = MKLocalSearchCompleter()
    let searchController = UISearchController(searchResultsController: nil)
    var results: [MKLocalSearchCompletion] = []
    
    weak var previousVC: ReminderInputViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // stops the navigation bar from behaving oddly
        self.definesPresentationContext = true
        
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly

        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        
        navigationController?.isNavigationBarHidden = false
        
        // Adds the search controller and gives it a white background
        let searchControllerBar = searchController.searchBar
        searchControllerBar.tintColor = UIColor.white
        searchControllerBar.barTintColor = UIColor.white
        
        if let textfield = searchControllerBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        
        searchController.dimsBackgroundDuringPresentation = false
        
        // Adds the search bar to the navigation controller
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
 
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = results[indexPath.row].title
        cell.detailTextLabel?.text = results[indexPath.row].subtitle

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = MKLocalSearch.Request(completion: results[indexPath.row])
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (response, _) in
     
            if let response = response{
                self.previousVC.selectedLocation = response.mapItems.first
                self.previousVC.viewDidLoad()
                self.searchController.searchBar.resignFirstResponder()
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }
    }

}

extension LocationUpdatingTableViewController: MKLocalSearchCompleterDelegate{
    
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
        tableView.reloadData()
    }
    
}

extension LocationUpdatingTableViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter.queryFragment = searchController.searchBar.text ?? ""
    }
    
}



