//
//  Engineer.swift
//  ZNGJ
//
//  Created by en li on 17/3/22.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation

class Engineer
{
	init()
	{
		self.cellphone = "13xxxxxxxxxx"
		self.ID = 0  // Global Unique ID for Engineer
		self.active = "inactive"
		self.name = "未认证"
		self.serviceType = "请选择"
		self.liveCity = "请选择"
		self.serviceArea = "请选择"
	}
	
	func refresh(data:Dictionary<String, Any>)
	{
		self.cellphone = data["cellphone"] as! String
		self.ID = data["engineerId"] as! Int
		self.active = data["active"] as! String
		if data["name"] as? String != nil {
			self.name = data["name"] as! String
		}
		if data["serviceType"] as? String != nil {
			self.serviceType = data["serviceType"] as! String
		}
		if data["serviceArea"] as? String != nil {
			self.serviceArea = data["serviceArea"] as! String
		}
		if data["liveCity"] as? String != nil {
			self.liveCity = data["liveCity"] as! String
		}
		if data["profileImage"] as? String != nil {
			self.profileImage = data["profileImage"] as! String
		}
		if data["shenfenImage"] as? String != nil {
			self.shenfenImage = data["shenfenImage"] as! String
		}
		if data["zhengshuImage"] as? String != nil {
			self.zhengshuImage = data["zhengshuImage"] as! String
		}
	}
	
	var cellphone:String!
	var ID:Int!
	var active:String!
	var name:String!
	var serviceType:String!
	var serviceArea:String!
	var liveCity:String!
	var profileImage:String!
	var shenfenImage:String!
	var zhengshuImage:String!
}
