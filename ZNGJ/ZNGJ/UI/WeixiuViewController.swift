//
//  WeixiuViewController.swift
//  ZNGJ
//
//  Created by en li on 17/1/5.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation
import MapKit

class WeixiuViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	
	// 今日维修信息
	@IBOutlet weak var onlineHours: UILabel!
	@IBOutlet weak var orderCount: UILabel!
	@IBOutlet weak var todaysPayment: UILabel!
	@IBOutlet weak var dealRatio: UILabel!
	
	@IBAction func showTodayOrders(_ sender: UIButton) {
		
	}
	
    // map related stuffs
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var geoCoder: CLGeocoder!
    var placeMark: CLPlacemark!
    
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.geoCoder = CLGeocoder();
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showTodayOrders" else {
            return
        }
		
		// Prepare Order Data
    }
    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard userLocation.coordinate.latitude != 0.0 && userLocation.coordinate.longitude != 0.0 else {
            return
        }
        //let once = { self.mapView.setCenter(userLocation.coordinate, animated: true) }()
        let once = {
            
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegionMake(userLocation.coordinate, span)
            self.mapView.setRegion(region, animated: true)
        }()
        _ = once
        
        
        self.geoCoder.reverseGeocodeLocation(self.mapView.userLocation.location!, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                guard placemarks.count > 0 else {
                    return
                }
                self.placeMark = placemarks[0]
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
        
    {
        if (status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.denied) {
            let alert = UIAlertController(title: "Location Disabled", message: "Please enable location services in the Settings app.", preferredStyle:UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            // This will implicitly try to get the user's location, so this can't be set
            // until we know the user granted this app location access
            self.mapView.showsUserLocation = true
        }
    }
    
    
    /*
 
 
 	
 
 - (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
 
 self.getAddressButton.enabled = NO;
 
 if (!self.presentedViewController) {
 NSString *message = nil;
 if (error.code == kCLErrorLocationUnknown) {
 // If you receive this error while using the iOS Simulator, location simulatiion may not be on.  Choose a location from the Debug > Simulate Location menu in Xcode.
 message = @"Your location could not be determined.";
 }
 else {
 message = error.localizedDescription;
 }
 
 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
 message:message
 preferredStyle:UIAlertControllerStyleAlert];
 [alert addAction:[UIAlertAction actionWithTitle:@"OK"
 style:UIAlertActionStyleDefault
 handler:nil]];
 [self presentViewController:alert animated:YES completion:nil];
 }
 }
 
 - (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
 if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Disabled"
 message:@"Please enable location services in the Settings app."
 preferredStyle:UIAlertControllerStyleAlert];
 [alert addAction:[UIAlertAction actionWithTitle:@"OK"
 style:UIAlertActionStyleDefault
 handler:nil]];
 [self presentViewController:alert animated:YES completion:nil];
 }
 else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
 // This will implicitly try to get the user's location, so this can't be set
 // until we know the user granted this app location access
 self.mapView.showsUserLocation = YES;
 }
 }*/
}
