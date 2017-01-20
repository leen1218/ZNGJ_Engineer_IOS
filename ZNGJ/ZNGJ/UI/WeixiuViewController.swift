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
	@IBOutlet weak var orderReserved: UILabel!
	@IBOutlet weak var orderTodayCount: UILabel!
	@IBOutlet weak var todaysPayment: UILabel!
	@IBOutlet weak var dealRatio: UILabel!
	
	@IBAction func showTodayOrders(_ sender: UIButton) {
		
	}
	
    // map related stuffs
    let verticalSpan = 0.005
    let horizontalSpan = 0.005
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var geoCoder: CLGeocoder!
    var placeMark: CLPlacemark!
    var boundingRegion: MKCoordinateRegion!
    var localSearch: MKLocalSearch!
    var userCoordinate: CLLocationCoordinate2D!
    
    // dictionary for return object from MKLocalSearch
    var mapAnnotationItems = [Int: MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.geoCoder = CLGeocoder();
		
		// 初始化界面
		self.setupUI()
    }
	
	func setupUI()
	{
		let orderCountReserved:Int = UserModel.SharedUserModel().orderCountOfReserved!
		self.orderReserved.text = String(orderCountReserved)
		
		let orderCNT:Int = UserModel.SharedUserModel().orderCountOfToday!
		self.orderTodayCount.text = String(orderCNT)
		
		let todaysPay:Float = UserModel.SharedUserModel().todaysPayment!
		self.todaysPayment.text = String(todaysPay) + "元"
		
		let ratio:Int = UserModel.SharedUserModel().dealRatio!
		self.dealRatio.text = String(ratio) + "%"
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showReservedOrders" else {
            return
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isEqual(mapView.userLocation) else {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "Pin")
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.canShowCallout = true
        return annotationView
    }
    

    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard self.locationManager != nil else {
            return
        }
        
        guard userLocation.coordinate.latitude != 0.0 && userLocation.coordinate.longitude != 0.0 else {
            return
        }
        
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        self.locationManager = nil
        
        self.userCoordinate = userLocation.coordinate
        //let once = { self.mapView.setCenter(userLocation.coordinate, animated: true) }()
        //let once = {
            
            let span = MKCoordinateSpanMake(horizontalSpan, verticalSpan)
            let region = MKCoordinateRegionMake(userLocation.coordinate, span)
            self.mapView.setRegion(region, animated: true)
        
        //}()
        //_ = once
        
        
        self.geoCoder.reverseGeocodeLocation(self.mapView.userLocation.location!, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                guard placemarks.count > 0 else {
                    return
                }
                self.placeMark = placemarks[0]
            }
        })
        
        self.showAllAddressestoAnnotations()
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
    
    
     // search related method
    func showAllAddressestoAnnotations() {
        for item in UserModel.SharedUserModel().orderManager.orderList {
            searchAndShowAddress(item)
        }
    }
    
    func searchAndShowAddress(_ order: Order) {
        let addressString = order.orderAddress
        
        let newRegion = MKCoordinateRegion.init(center: self.userCoordinate, span: MKCoordinateSpan.init(latitudeDelta: horizontalSpan, longitudeDelta: verticalSpan))
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = addressString
        request.region = newRegion
        let completionHandler = { (response: MKLocalSearchResponse?, error: Error?) -> Void in
            if (error != nil) {
                // error handling
                
            } else {
                
                self.boundingRegion = response?.boundingRegion
                synchronizd(self) {
                    self.mapAnnotationItems[order.orderId] = response?.mapItems[0]
                    if (self.mapAnnotationItems.count == UserModel.SharedUserModel().orderManager.orderList.count) {
                        // all annotation returned, we add all to mapview
                        for item in self.mapAnnotationItems.values {
                            self.addAnnotation(item)
                        }
                    }
                }
            }
        }
        
        let searchInstance = MKLocalSearch.init(request: request)
        searchInstance.start(completionHandler: completionHandler)
    }
    
    func addAnnotation(_ mapItem: MKMapItem?) {
        guard let mapItem = mapItem else {
            return
        }
        let annotation = OrderAnnotation(mapItem.placemark.location!.coordinate, title: mapItem.name!, subtitle: "")
        self.mapView.addAnnotation(annotation)
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
