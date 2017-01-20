//
//  Order.swift
//  ZNGJ
//
//  Created by HuangBing on 1/17/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class Order{
	
	init()
	{
	}
	
	init(order_id:Int, order_address:String) {
		self.orderId = order_id
		self.orderAddress = order_address
	}
    
    var orderId: Int = 0
    var orderAddress: String = ""
    
}
