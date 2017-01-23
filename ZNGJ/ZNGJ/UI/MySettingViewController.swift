//
//  MySettingViewController.swift
//  ZNGJ
//
//  Created by en li on 17/1/5.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation

class MySettingViewController: UIViewController {
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showCompletedOrders"
		{
			guard segue.destination is ReservedOrdersTVC else {
				print("已完成订单跳转的页面不是Table View")
				return
			}
			
			let reservedOrderListTVC: ReservedOrdersTVC = segue.destination as! ReservedOrdersTVC
			reservedOrderListTVC.orders = UserModel.SharedUserModel().orderManager.uncompletedOrders + UserModel.SharedUserModel().orderManager.completedOrders
		}
	}
}
