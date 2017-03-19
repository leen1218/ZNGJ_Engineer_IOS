//
//  MySettingViewController.swift
//  ZNGJ
//
//  Created by en li on 17/1/5.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation

class MySettingViewController: UIViewController, RequestHandler{
	
	
	@IBOutlet weak var profile: UIImageView!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var phone: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupUI()
	}
	
	func setupUI()
	{
		
	}
	
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
		else if segue.identifier == "showOrderPayments"
		{
			guard segue.destination is IncomeTVC else {
				print("账单跳转的页面不是Table View")
				return
			}
			
			let orderPaymentsListTVC: IncomeTVC = segue.destination as! IncomeTVC
			orderPaymentsListTVC.completedOrders = UserModel.SharedUserModel().orderManager.completedOrders
		}
	}
	
	@IBAction func logout(_ sender: UIButton) {
		let request:ZNGJRequest = ZNGJRequestManager.shared().createRequest(ENUM_REQUEST_LOGOUT)
		let params:Dictionary<String, String> = ["cellphone":UserModel.SharedUserModel().cellphone!]
		request.params = params
		request.handler = self
		request.start()
	}
	
	func onSuccess(_ response: Any!) {
		let result_json = response as! Dictionary<String, Any>
		if (result_json["status"] != nil) {
			if (result_json["status"] as! String == "200") {
				// 1. 清除用户名，密码在本地数据存储
				UserDefaults.standard.removeObject(forKey: "username")
				UserDefaults.standard.removeObject(forKey: "password")
				
				// 2. 到客户登录界面
				let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
				let navigationVC = UINavigationController.init(rootViewController: loginVC)
				self.present(navigationVC, animated: true, completion: {})
			} else if (result_json["status"] as! String == "401") {
				showAlert(title: "手机号未注册", message:"手机号不存在，请注册！", parentVC: self, okAction: nil)
			}
		} else {
			showAlert(title: "请求失败", message:"请重新登录", parentVC: self, okAction: nil)
		}
	}
	func onFailure(_ error: Error!) {
		showAlert(title: "请求失败", message: "退出请求失败，请重试!", parentVC: self, okAction: nil)
	}
}
