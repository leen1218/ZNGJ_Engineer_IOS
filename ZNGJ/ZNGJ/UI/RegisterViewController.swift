//
//  RegisterViewController.swift
//  ZNGJ
//
//  Created by en li on 16/12/26.
//  Copyright © 2016年 en li. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate
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
	
	@IBAction func register(_ sender: UIButton) {
		// TODO : HTTP request to register
	}
	
	@IBAction func getAuthCode(_ sender: UIButton) {
		// TODO : HTTP request to get message code
	}
	
	// adjust view height when keyboard show
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
