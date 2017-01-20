//
//  OrderManager.swift
//  ZNGJ
//
//  Created by HuangBing on 1/17/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class OrderManager {
    var orderList: [Order] = []
    
    init() {
        orderList = [Order(), Order(), Order(), Order()]
        orderList[0].orderId = 0
        orderList[0].orderAddress = "浙江省杭州市延安路546号"
        orderList[1].orderId = 1
        orderList[1].orderAddress = "浙江省杭州市省府路8号"
        orderList[2].orderId = 2
        orderList[2].orderAddress = "浙江省杭州市省立同德医院"
        orderList[3].orderId = 3
        orderList[3].orderAddress = "浙江省杭州市元茂大厦"
    }
    
}
