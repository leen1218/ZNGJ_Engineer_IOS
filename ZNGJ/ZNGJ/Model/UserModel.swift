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
		
	}
	
	var orderManager:OrderManager!
	
	// Enginner Info
	var orderCountOfReserved:Int!
	var orderCountOfToday:Int!
	var todaysPayment:Float!
	var dealRatio:Int!
}
