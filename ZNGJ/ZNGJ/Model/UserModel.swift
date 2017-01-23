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
		let personalOrders = data["personalOrders"] as! [Dictionary<String, Any>]
		
		// 设置用户数据
		let orderTotalCount = personalOrders.count
		var orderReserved:Int = 0
		var orderReservedOfToday:Int = 0
		var payments:Float = 0.0
		
		for personalOrder in personalOrders {
			let orderStatus:String = personalOrder["OrderStatus"] as! String
			if orderStatus == "进行中" {
				orderReserved += 1
				
				// 个人未完成队列
				let order_id:Int = personalOrder["ID"] as! Int
				let order_address:String = personalOrder["Address"] as! String
				UserModel.SharedUserModel().orderManager.addOrderToUnCompletedList(order: Order(order_id: order_id, order_address: order_address))
			} else if orderStatus == "已完成" {
				orderReservedOfToday += 1
				let orderPayment = Float(personalOrder["ActualAmount"] as! String)
				payments += orderPayment!
				
				// 个人已完成队列
				let order_id:Int = personalOrder["ID"] as! Int
				let order_address:String = personalOrder["Address"] as! String
				UserModel.SharedUserModel().orderManager.addOrderToCompletedList(order: Order(order_id: order_id, order_address: order_address))
			}
		}
		self.orderCountOfToday = orderReservedOfToday
		self.orderCountOfReserved = orderReserved
		if orderTotalCount == 0 {
			self.dealRatio = 100
		} else {
			self.dealRatio = Int(Double(self.orderCountOfReserved!) * 100.0 / Double(orderTotalCount))
		}
		self.todaysPayment = payments
		
		// 设置订单数据
		let unreservedOrders = data["unreservedOrders"] as! [Dictionary<String, Any>]
		for unreservedOrder in unreservedOrders {
			let orderStatus:String = unreservedOrder["OrderStatus"] as! String
			if orderStatus != "进行中" {
				continue
			}
			let order_id:Int = unreservedOrder["ID"] as! Int
			let order_address:String = unreservedOrder["Address"] as! String
			UserModel.SharedUserModel().orderManager.addOrderToUnreservedList(order: Order(order_id: order_id, order_address: order_address))
		}
	}
	
	var orderManager:OrderManager!
	
	// Enginner Info
	var orderCountOfReserved:Int!
	var orderCountOfToday:Int!
	var todaysPayment:Float!
	var dealRatio:Int!
}
