//
//  RegisterViewController.swift
//  ZNGJ
//
//  Created by en li on 16/12/26.
//  Copyright © 2016年 en li. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate, RequestHandler
{
	
	@IBOutlet weak var cellPhone: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var confirmPassword: UITextField!
	@IBOutlet weak var authCode: UITextField!
	
	var currTextField: UITextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 设置文本框格式
		self.setupTextField()
		
		// 点击空白取消键盘
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:))))
	}
	
	func setupTextField()
	{
		// delegate 设置
		self.cellPhone.delegate = self
		self.password.delegate = self
		self.confirmPassword.delegate = self
		self.authCode.delegate = self
		
		// 返回按钮设置
		self.cellPhone.returnKeyType = UIReturnKeyType.done;
		self.password.returnKeyType = UIReturnKeyType.done;
		self.confirmPassword.returnKeyType = UIReturnKeyType.done;
		self.authCode.returnKeyType = UIReturnKeyType.done;
		
		// 键盘格式
		self.cellPhone.keyboardType = UIKeyboardType.phonePad;
		self.password.keyboardType = UIKeyboardType.phonePad;
		self.confirmPassword.keyboardType = UIKeyboardType.phonePad;
		self.authCode.keyboardType = UIKeyboardType.phonePad;
		
		// 开启一键删除操作
		self.cellPhone.clearsOnBeginEditing = true;
		self.password.clearsOnBeginEditing = true;
		self.confirmPassword.clearsOnBeginEditing = true;
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
	
	func handleSingleTap(_ sender: UITapGestureRecognizer) {
		if sender.state == .ended {
			if self.currTextField != nil {
				self.currTextField.resignFirstResponder()
			} else {
				return
			}
		}
		sender.cancelsTouchesInView = false
	}
	
	@IBAction func register(_ sender: UIButton) {
		// 1. 检验密码是否一致
		guard self.password.text! == self.confirmPassword.text! else {
			self.showAlert(title: "密码不一致", message: "您两次输入的密码不一致，请确认！")
			return
		}
		
		// 2. 检测code是否为空
		guard self.authCode.text != nil else {
			self.showAlert(title: "验证码错误", message: "验证码不能为空!")
			return
		}
		
		// 3. 向服务器发送注册请求
		let request:ZNGJRequest = ZNGJRequestManager.shared().createRequest(ENUM_REQUEST_REGISTER)
		let params:Dictionary<String, String> = ["cellphone":self.cellPhone.text!, "password":self.password.text!, "code":self.authCode.text!]
		request.params = params
		request.handler = self
		request.start()
	}
	
	@IBAction func getAuthCode(_ sender: UIButton) {
		// 1. 检测手机号是否为空
		guard self.cellPhone.text != nil else {
			self.showAlert(title: "手机号错误", message: "手机号码不能为空!")
			return
		}
		
		// 2. 向服务器发送注册码请求
		let request:ZNGJRequest = ZNGJRequestManager.shared().createRequest(ENUM_REQUEST_AUTHENTICATION_CODE)
		let params:Dictionary<String, String> = ["cellphone":self.cellPhone.text!]
		request.params = params
		request.handler = self
		request.start()
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
	
	
	/* 
	TextFeild adjust view height when keyboard show
	*/
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// register for keyboard notifications
		NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShow:"), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillHide:"), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	// 偏移view适应键盘的弹出高度
	func keyboardWillShow(_ notif: NSNotification)
	{
		if (self.currTextField == nil) {
			return;
		}
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
