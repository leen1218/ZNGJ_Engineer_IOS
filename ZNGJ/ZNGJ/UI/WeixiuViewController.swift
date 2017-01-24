//
//  WeixiuViewController.swift
//  ZNGJ
//
//  Created by en li on 17/1/5.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation
import MapKit

class WeixiuViewController: UIViewController, MAMapViewDelegate, AMapLocationManagerDelegate, MapSearchManagerDelegate {
	
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
    
    var geoCoder: CLGeocoder!
    var placeMark: CLPlacemark!
    var boundingRegion: MKCoordinateRegion!
    var userCoordinate: CLLocationCoordinate2D!
    var locationManager: AMapLocationManager!
    
    var mapView: MAMapView!
    
    var mapSearchManager: MapSearchManager!
    
    
    // dictionary for return object from MKLocalSearch
    var mapAnnotationItems = [Int: MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMap()
        self.locationManager = AMapLocationManager()
        self.locationManager.delegate = self
        self.geoCoder = CLGeocoder()
        
        self.mapSearchManager = MapSearchManager.init(orders: UserModel.SharedUserModel().orderManager.unreservedOrders)
        self.mapSearchManager.delegate = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //        self.locationManager.requestWhenInUseAuthorization()
        // replace the above line with the following if we use GaoDe map
        self.locationManager.startUpdatingLocation()
		
		// 初始化界面
		self.setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.mapSearchManager.cancelAllSearches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // begin search here
        self.mapSearchManager.beginSearch()
        
    }
    
    func initMap() {
        if (self.mapView == nil) {
            self.mapView = MAMapView()
            self.mapView.translatesAutoresizingMaskIntoConstraints = false
            self.mapView.delegate = self
            self.view.addSubview(self.mapView)
            
            // set the map size and position
            self.view.addConstraint(NSLayoutConstraint.init(item: self.mapView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0))
            self.view.addConstraint(NSLayoutConstraint.init(item: self.mapView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.32 * self.view.bounds.height))
            
            self.view.addConstraint(NSLayoutConstraint.init(item: self.mapView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0))
            self.view.addConstraint(NSLayoutConstraint.init(item: self.mapView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 0.6, constant: 0.0))
        }
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
		
		guard segue.destination is ReservedOrdersTVC else {
			print("未完成订单跳转的页面不是Table View")
			return
		}
		
		let reservedOrderListTVC: ReservedOrdersTVC = segue.destination as! ReservedOrdersTVC
		reservedOrderListTVC.orders = UserModel.SharedUserModel().orderManager.unreservedOrders
		
    }
    
    // MARK: MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        guard !annotation.isEqual(mapView.userLocation) else {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if (annotationView == nil) {
            annotationView = CustomAnnotationView.init(annotation: annotation, reuseIdentifier: "Pin")
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.canShowCallout = false
        
        if let newAnnotation = annotation as? OrderAnnotation {
            if let newView = annotationView as? CustomAnnotationView {
                newView.setOrderId(newAnnotation.orderIds, self)
            }
            
            
//            let calloutView = AnnotationCalloutView()
//            calloutView.translatesAutoresizingMaskIntoConstraints = false
//            
//
//            let views = ["calloutView": calloutView]
//            // need to use constraint instead of setting frame, otherwise the size will not be applied.
//            calloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[calloutView(240)]", options: [], metrics: nil, views: views))
//            calloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[calloutView(200)]", options: [], metrics: nil, views: views))
//            calloutView.setOrderId(newAnnotation.orderIds)
//            annotationView?.leftCalloutAccessoryView = calloutView
            
        }
        return annotationView
    }
    
    
    
    // MARK: MapSearchManagerDelegate
    func onSearchesFinish() {
        for item in self.mapSearchManager.resultMap.values {
            guard item.response != nil else {
                continue
            }
            let locationPoint = item.response.pois[0].location!
            let orderAnnotation = OrderAnnotation(CLLocationCoordinate2D.init(latitude: Double(locationPoint.latitude), longitude: Double(locationPoint.longitude)), title: "订单信息", subtitle: "", orderIds: item.orderIds)
            self.mapView.addAnnotation(orderAnnotation)
        }
    }
    
    // MARK: AMapLocationManagerDelegate
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        
        guard self.locationManager != nil else {
            return
        }
        
        guard location.coordinate.latitude != 0.0 && location.coordinate.longitude != 0.0 else {
            return
        }
        
        self.mapView.isShowsUserLocation = true
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        self.locationManager = nil
        
        self.userCoordinate = location.coordinate
        
        let span = MACoordinateSpanMake(horizontalSpan, verticalSpan)
        let region = MACoordinateRegionMake(location.coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
        
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didChange status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.denied) {
            let alert = UIAlertController(title: "Location Disabled", message: "Please enable location services in the Settings app.", preferredStyle:UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            // This will implicitly try to get the user's location, so this can't be set
            // until we know the user granted this app location access
            self.mapView.isShowsUserLocation = true
        }
    }
}
