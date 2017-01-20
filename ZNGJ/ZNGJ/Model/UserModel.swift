//
//  UserModel.swift
//  ZNGJ
//
//  Created by en li on 17/1/20.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation

class UserModel
{
	private init() {
		self.orderManager = OrderManager()
		self.orderCountOfReserved = 0
		self.orderCountOfToday = 0
		self.todaysPayment = 0.0
		self.dealRatio = 0
	}
	
	private static var model:UserModel? = nil
	
	public static func SharedUserModel() -> UserModel
	{
		if UserModel.model == nil
		{
			UserModel.model = UserModel()
		}
		return UserModel.model!
	}
	
	func setup(data:Dictionary<String, Any>)
	{
		let orders = data["orders"] as! [Dictionary<String, String>]
		
		// 设置用户数据
		let orderTotalCount = orders.count
		var orderReserved:Int = 0
		var orderReservedOfToday:Int = 0
		var payments:Float = 0.0
		
		for order in orders {
			let orderStatus:String? = order["OrderStatus"]
			guard orderStatus != nil else {
				continue
			}
			if orderStatus! == "进行中" {
				orderReserved += 1
			} else if orderStatus! == "已完成" {
				orderReservedOfToday += 1
				let orderPayment = Float(order["ActualAmount"]!)
				payments += orderPayment!
			}
		}
		self.orderCountOfToday = orderReservedOfToday
		self.orderCountOfReserved = orderReserved
		self.dealRatio = Int(Double(self.orderCountOfReserved!) * 100.0 / Double(orderTotalCount))
		self.todaysPayment = payments
		
		// 设置订单数据
	}
	
	var orderManager:OrderManager!
	
	// Enginner Info
	var orderCountOfReserved:Int!
	var orderCountOfToday:Int!
	var todaysPayment:Float!
	var dealRatio:Int!
}
