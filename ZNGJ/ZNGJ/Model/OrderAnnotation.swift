//
//  OrderAnnotation.swift
//  ZNGJ
//
//  Created by HuangBing on 1/17/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation
import MapKit

class OrderAnnotation : NSObject, MAAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var orderIds: [Int] = []
    
    init(_ coordinate: CLLocationCoordinate2D, title: String, subtitle: String, orderIds: [Int]) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.orderIds = orderIds
    }
}
