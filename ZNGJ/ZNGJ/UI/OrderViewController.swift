//
//  OrderViewController.swift
//  ZNGJ
//
//  Created by en li on 17/1/17.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation
class OrderViewController: UIViewController, RequestHandler {
	
	
	@IBOutlet weak var orderNO: UILabel!
	@IBOutlet weak var orderStatus: UILabel!
	@IBOutlet weak var bookingDate: UILabel!
	@IBOutlet weak var contact: UILabel!
	@IBOutlet weak var cellphone: UILabel!
	@IBOutlet weak var address: UILabel!
	@IBOutlet weak var reservedDate: UILabel!
	@IBOutlet weak var production: UILabel!
	
	@IBOutlet weak var acceptOrderBtn: UIButton!
	
	var order: Order!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//
		self.updateUI()
	}
	
	func updateUI()
	{
		self.orderNO.text = self.order.orderNo
		self.orderStatus.text = self.order.orderStatus
		self.bookingDate.text = self.order.orderBookingDate
		self.contact.text = self.order.orderContact
		self.cellphone.text = self.order.orderCellPhone
		self.address.text = self.order.orderAddress
		self.reservedDate.text = self.order.orderReservedDate
		self.production.text = self.order.orderProduction
		
		if self.order.orderStatus == "未接单"
		{
			self.acceptOrderBtn.isHidden = false
		} else {
			self.acceptOrderBtn.isHidden = true
		}
	}
	
	@IBAction func acceptOrder(_ sender: UIButton) {
		let orderId = order.orderId
		let engineerId = UserModel.SharedUserModel().engineerId!
		
		let request:ZNGJRequest = ZNGJRequestManager.shared().createRequest(ENUM_REQUEST_ACCEPT_ORDER)
		let params:Dictionary<String, String> = ["orderId":String(orderId), "engineerId":String(engineerId)]
		request.params = params
		request.handler = self
		request.start()
	}
	
	func onSuccess(_ response: Any!) {
		let result_json = response as! Dictionary<String, Any>
		if (result_json["status"] != nil) {
			if (result_json["status"] as! String == "200") {
				// 接单成功，弹出提示，跳转到接单界面
				showAlert(title: "接单成功", message: "已成功抢单，请在未完成订单里查看!", parentVC: self)
			} else if (result_json["status"] as! String == "401") {
				// 接单失败，订单过期，已被抢单
				showAlert(title: "接单失败", message: "当前订单已被抢，请刷新!", parentVC: self)
			} else if (result_json["status"] as! String == "402") {
				// 接单失败，订单ID无效
				showAlert(title: "接单失败", message: "当前订单已失效，请重试!", parentVC: self)
			}
			// TODO, 跳转到维修主界面
		} else {
			showAlert(title: "接单失败", message: "接单请求失败，请重试!", parentVC: self)
		}
	}
	func onFailure(_ error: Error!) {
		showAlert(title: "接单失败", message: "接单请求失败，请重试!", parentVC: self)
	}
	
}
