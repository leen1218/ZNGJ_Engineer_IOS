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
    var orderAddress: String = "初始地址"
	
	var orderNo: String = "初始编号"
	var orderStatus: String = "未接单"
	var orderBookingDate: String = "初始时间"
	var orderContact: String = "初始联系人"
	var orderCellPhone: String = "初始手机号"
	var orderReservedDate: String = "初始时间"
	var orderProduction: String = "初始类目"
    
}
