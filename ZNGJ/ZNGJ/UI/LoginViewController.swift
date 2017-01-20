//
//  LoginViewController.swift
//  ZNGJ
//
//  Created by en li on 16/12/23.
//  Copyright © 2016年 en li. All rights reserved.
//

import UIKit
import UserNotifications

class LoginViewController: UIViewController, UITextFieldDelegate, RequestHandler
{
	@IBOutlet weak var cellphone: UITextField!
	@IBOutlet weak var password: UITextField!
	var currTextField: UITextField!

	@IBOutlet weak var autoLoginCheckBox: UIButton!
	@IBOutlet weak var rememberPWCheckBox: UIButton!
	
	// 用户名密码默认全部记录在userdefault standard中
	var rememberPasswordCheck: Bool = true
	var autoLoginCheck: Bool = true
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 设置文本框格式
		self.setupTextField()
		
		// 点击空白取消键盘
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:))))
		
		// Try to login directly
		self.autoLogin()
	}
	
	func autoLogin()
	{
		// 从user default standard中读取用户名密码
		let username:String? = UserDefaults.standard.string(forKey: "username")
		guard username != nil else {
			return
		}
		let password:String? = UserDefaults.standard.string(forKey: "password")
		guard password != nil else {
			return
		}
		
		// 从user default standard中读取用户设置, 进行UI初始化
		let rememberPassword:String? = UserDefaults.standard.string(forKey: "rememberPassword")
		if rememberPassword == nil {
			self.rememberPasswordCheck = true
		} else {
			self.rememberPasswordCheck = rememberPassword! == "TRUE" ? true : false
		}
		if self.rememberPasswordCheck {
			self.cellphone.text = username
			self.password.text = password
		}
		let autoLogin:String? = UserDefaults.standard.string(forKey: "autoLogin")
		if autoLogin == nil {
			self.autoLoginCheck = true
		} else {
			self.autoLoginCheck = autoLogin! == "TRUE" ? true : false
		}
		self.updateAutoLoginUI()
		
		if self.autoLoginCheck {
			self.doLogin(username: username!, password: password!)
		}
	}
	
	func updateAutoLoginUI() {
		if self.autoLoginCheck {
			self.autoLoginCheckBox.setImage(UIImage.init(named: "box-checked"), for: UIControlState.normal)
		} else {
			self.autoLoginCheckBox.setImage(UIImage.init(named: "box-empty"), for: UIControlState.normal)
		}
		
		if self.rememberPasswordCheck {
			self.rememberPWCheckBox.setImage(UIImage.init(named: "box-checked"), for: UIControlState.normal)
		} else {
			self.rememberPWCheckBox.setImage(UIImage.init(named: "box-empty"), for: UIControlState.normal)
		}
	}
	
	func setupTextField()
	{
		// delegate 设置
		self.cellphone.delegate = self
		self.password.delegate = self
		
		// 返回按钮设置
		self.cellphone.returnKeyType = UIReturnKeyType.done
		self.password.returnKeyType = UIReturnKeyType.done
		
		// 键盘格式
		self.cellphone.keyboardType = UIKeyboardType.phonePad
		self.password.keyboardType = UIKeyboardType.phonePad
		
		// 开启一键删除操作
		self.password.clearsOnBeginEditing = true
		
		// 密码模式
		self.password.isSecureTextEntry = true
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
	
	@IBAction func login(_ sender: UIButton) {
		// 1. 检测手机号密码是否为空
		guard self.cellphone.text != "" && self.password.text != "" else {
			self.showAlert(title: "登录失败", message: "用户名或者密码不能为空!")
			return
		}
	
		// 2. 向服务器发送登录请求
		self.doLogin(username: self.cellphone.text!, password: self.password.text!)
	}
	
	func doLogin(username:String, password:String)
	{
		let request:ZNGJRequest = ZNGJRequestManager.shared().createRequest(ENUM_REQUEST_LOGIN)
		let params:Dictionary<String, String> = ["cellphone":username, "password":password]
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
		let result_json = response as! Dictionary<String, Any>
		if (result_json["status"] != nil) {
			if (result_json["status"] as! String == "200") {
				// 1. 登录成功， 注册推送
				self.registerDeviceForPushNotification()
				
				// 2. 更新用户名，密码到本地数据存储
				if self.rememberPasswordCheck || self.autoLoginCheck {
					UserDefaults.standard.set(self.cellphone.text!, forKey: "username")
					UserDefaults.standard.set(self.password.text!, forKey: "password")
					UserDefaults.standard.set(self.autoLoginCheck ? "TRUE" : "FALSE", forKey: "autoLogin")
					UserDefaults.standard.set(self.rememberPasswordCheck ? "TRUE" : "FALSE", forKey: "rememberPassword")
				}
				
				// 3. 获取用户数据
				let user_info = result_json["user_info"] as? Dictionary<String, Any>
				if user_info != nil {
					UserModel.SharedUserModel().setup(data: user_info!)
				}
				
				// 4. 到客户管理界面
				let mainTBVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTBViewController")
				self.present(mainTBVC, animated: true, completion: {
				})
			} else if (result_json["status"] as! String == "401") {
				showAlert(title: "手机号未注册", message:"手机号不存在，请注册！")
			} else if (result_json["status"] as! String == "402") {
				showAlert(title: "密码不正确", message:"密码不正确，请重新输入！")
			} else {
				showAlert(title: "请求失败", message:"请重新登录")
			}
		} else {
			showAlert(title: "请求失败", message:"请重新登录")
		}
	}
	func onFailure(_ error: Error!) {
		showAlert(title: "请求失败", message: "登录请求失败，请重试!")
	}
	
	func registerDeviceForPushNotification()
	{
		let application = UIApplication.shared
		// iOS 10 support
		if #available(iOS 10, *) {
			UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
			application.registerForRemoteNotifications()
		} // iOS 9 support
		else if #available(iOS 9, *) {
			UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
			UIApplication.shared.registerForRemoteNotifications()
		} // iOS 8 support
		else if #available(iOS 8, *) {
			UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
			UIApplication.shared.registerForRemoteNotifications()
		}
			// iOS 7 support
		else {
			application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
		}
	}
	
	// 自动登录
	@IBAction func checkAutoLogin(_ sender: UIButton) {
		self.autoLoginCheck = !self.autoLoginCheck
		self.updateAutoLoginUI()
	}
	
	// 记住密码
	@IBAction func checkRecordPassword(_ sender: UIButton) {
		self.rememberPasswordCheck = !self.rememberPasswordCheck
		self.updateAutoLoginUI()
	}
	
	// adjust view height when keyboard show
	override func viewWillAppear(_ animated: Bool) {
		// register for keyboard notifications
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	} // Selector("keyboardWillHide:")
	
	override func viewWillDisappear(_ animated: Bool) {
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
