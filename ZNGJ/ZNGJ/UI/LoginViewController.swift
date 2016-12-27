//
//  LoginViewController.swift
//  ZNGJ
//
//  Created by en li on 16/12/23.
//  Copyright © 2016年 en li. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
{
	
	@IBOutlet weak var username: UITextField!
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
		self.username.delegate = self
		self.password.delegate = self
		
		// 返回按钮设置
		self.username.returnKeyType = UIReturnKeyType.done;
		self.password.returnKeyType = UIReturnKeyType.done;
		
		// 键盘格式
		self.username.keyboardType = UIKeyboardType.numberPad;
		self.password.keyboardType = UIKeyboardType.numberPad;
		
		// 开启一键删除操作
		self.username.clearsOnBeginEditing = true;
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
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goRegister" {
		}
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
	
}
