//
//  PlacemarkViewController.swift
//  ZNGJ
//
//  Created by HuangBing on 1/12/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation
import MapKit

class PlacemarkViewController: UITableViewController {
    var placemark: CLPlacemark!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Get the thoroughfare table cell and set the detail text to show the thoroughfare.
        var cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        cell?.detailTextLabel?.text = self.placemark.thoroughfare
        
        cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        cell?.detailTextLabel?.text = self.placemark.subThoroughfare
        
        cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))
        cell?.detailTextLabel?.text = self.placemark.locality
        
        cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0))
        cell?.detailTextLabel?.text = self.placemark.subLocality
        
        cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0))
        cell?.detailTextLabel?.text = self.placemark.administrativeArea
        
        cell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0))
        cell?.detailTextLabel?.text = self.placemark.subAdministrativeArea
        
        cell = self.tableView.cellForRow(at: IndexPath(row: 6, section: 0))
        cell?.detailTextLabel?.text = self.placemark.postalCode
        
        cell = self.tableView.cellForRow(at: IndexPath(row: 7, section: 0))
        cell?.detailTextLabel?.text = self.placemark.country
        
        cell = self.tableView.cellForRow(at: IndexPath(row: 8, section: 0))
        cell?.detailTextLabel?.text = self.placemark.isoCountryCode
        
        // Tell the table to reload section zero of the table.
        
        self.tableView.reloadSections(IndexSet(integer:0), with: UITableViewRowAnimation.none)
        
    }
}
