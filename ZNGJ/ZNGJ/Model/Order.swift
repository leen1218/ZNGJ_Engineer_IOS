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
	
	init(data:Dictionary<String, Any>) {
		if (data["ID"] as? Int != nil) {
			self.orderId = data["ID"] as! Int
		}
		if (data["Address"] as? String != nil) {
			self.orderAddress = data["Address"] as! String
		}
		if (data["OrderNo"] as? String != nil) {
			self.orderNo = data["OrderNo"] as! String
		}
		if (data["OrderStatus"] as? String != nil ) {
			self.orderStatus = data["OrderStatus"] as! String
		}
		if (data["SubmitDate"] as? String != nil) {
			self.orderBookingDate = data["SubmitDate"] as! String
		}
		if (data["Contact"] as? String != nil) {
			self.orderContact = data["Contact"] as! String
		}
		if (data["CellPhone"] as? String != nil) {
			self.orderCellPhone = data["CellPhone"] as! String
		}
		if (data["BookTime"] as? String != nil) {
			self.orderReservedDate = data["BookTime"] as! String
		}
		if (data["ProductName"] as? String != nil) {
			self.orderProduction = data["ProductName"] as! String
		}
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
	var orderPayment: Float = 888.0
    
}
