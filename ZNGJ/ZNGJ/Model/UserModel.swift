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
		let orderReserved = data["orderReserved"] as? Int
		guard orderReserved != nil else {
			return
		}
		self.orderCountOfReserved = orderReserved
		
		let orderReservedOfToday = data["orderReservedOfToday"] as? Int
		guard orderReservedOfToday != nil else {
			return
		}
		self.orderCountOfToday = orderReservedOfToday
		
		let payments = data["todaysPayment"] as? Float
		guard payments != nil else {
			return
		}
		self.todaysPayment = payments
		
		let ratio = data["dealRatio"] as? Int
		guard ratio != nil else {
			return
		}
		self.dealRatio = ratio
		
		// Orders
	}
	
	var orderManager:OrderManager!
	
	// Enginner Info
	var orderCountOfReserved:Int!
	var orderCountOfToday:Int!
	var todaysPayment:Float!
	var dealRatio:Int!
}
