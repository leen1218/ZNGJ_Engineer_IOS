//
//  LoginViewController.swift
//  ZNGJ
//
//  Created by en li on 16/12/23.
//  Copyright © 2016年 en li. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, RequestHandler
{
	
	@IBOutlet weak var cellphone: UITextField!
	@IBOutlet weak var password: UITextField!
	
	var currTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 设置文本框格式
		self.setupTextField()
	}
	
	func setupTextField()
	{
		// delegate 设置
		self.cellphone.delegate = self
		self.password.delegate = self
		
		// 返回按钮设置
		self.cellphone.returnKeyType = UIReturnKeyType.done;
		self.password.returnKeyType = UIReturnKeyType.done;
		
		// 键盘格式
		self.cellphone.keyboardType = UIKeyboardType.phonePad;
		self.password.keyboardType = UIKeyboardType.phonePad;
		
		// 开启一键删除操作
		self.cellphone.clearsOnBeginEditing = true;
		self.password.clearsOnBeginEditing = true;
	}
	
	//TextField - Delegate
	func textFieldDidEndEditing(_ textField: UITextField) {
		self.currTextField = nil
	}
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.currTextField = textField
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	@IBAction func login(_ sender: UIButton) {
		// 1. 检测手机号密码是否为空
		guard self.cellphone.text != nil && self.password.text != nil else {
			self.showAlert(title: "验证码错误", message: "验证码不能为空!")
			return
		}
		
		// 2. 向服务器发送登录请求
		let request:ZNGJRequest = ZNGJRequestManager.shared().createRequest(ENUM_REQUEST_LOGIN)
		let params:Dictionary<String, String> = ["cellphone":self.cellphone.text!, "password":self.password.text!]
		request.params = params
		request.handler = self
		request.start()

	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goRegister" {
		}
	}
	
	// Request handler protocal
	func onSuccess(_ response: Any!) {
		let result_json = response as? Dictionary<String, String>
		if (result_json != nil) {
			if (result_json?["msg"] != nil) {
				let msg = result_json?["msg"]
				showAlert(title: "请求返回", message: msg!)
			} else {
				showAlert(title: "请求失败", message:"请重新发送")
			}
		}
	}
	func onFailure(_ error: Error!) {
		showAlert(title: "请求失败", message: "网络请求失败，请重试!")
	}
	
	// 自动登录
	@IBAction func checkAutoLogin(_ sender: UIButton) {
	}
	
	// 记住密码
	@IBAction func checkRecordPassword(_ sender: UIButton) {
	}
	
	// adjust view height when keyboard show
	override func viewWillAppear(_ animated: Bool) {
		// register for keyboard notifications
		NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShow:"), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillHide:"), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	// 偏移view适应键盘的弹出高度
	func keyboardWillShow(_ notif: NSNotification)
	{
		//keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
		if let userInfo = notif.userInfo
		{
			if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
			{
				let viewframe:CGRect = self.view.frame;
				let textOrigin:CGPoint = self.currTextField.frame.origin;
				
				let offset:CGFloat = (viewframe.size.height - keyboardSize.height) - (viewframe.origin.y + textOrigin.y);
				if (offset < 0) {
					self.animateViewUp(up: true, withOffset: -(Int)(offset) )
				}
			} else {
				// no UIKeyboardFrameBeginUserInfoKey entry in userInfo
			}
		} else {
			// no userInfo dictionary in notification
		}
	}
	
	func keyboardWillHide(_ notif : NSNotification)
	{
		if (self.view.frame.origin.y < 0)
		{
			self.animateViewUp(up: false, withOffset: -(Int)(self.view.frame.origin.y))
		}
	}
	
	// 上移View，如果被keyboard盖住
	func animateViewUp(up: Bool, withOffset offset:Int)
	{
		let movementDuration:Float = 0.5;
		
		let movement:Int = (up ? -offset : offset);
		
		UIView.beginAnimations("anim", context: nil)
		UIView.setAnimationBeginsFromCurrentState(true)
		UIView.setAnimationDuration(TimeInterval(movementDuration))
		self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
		UIView.commitAnimations()
	}
	
	func showAlert(title: String, message : String)
	{
		let alertController = UIAlertController(title: title,
		                                        message: message,
		                                        preferredStyle: .alert)
		let okAction = UIAlertAction(title: "确定", style: .default, handler: {
			action in
		})
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
}
