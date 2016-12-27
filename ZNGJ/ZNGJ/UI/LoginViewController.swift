//
//  LoginViewController.swift
//  ZNGJ
//
//  Created by en li on 16/12/23.
//  Copyright © 2016年 en li. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	
	
	@IBAction func login(_ sender: UIButton) {
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goRegister" {
			NSLog("prepare");
		}
	}
	
	// 自动登录
	@IBAction func checkAutoLogin(_ sender: UIButton) {
	}
	
	// 记住密码
	@IBAction func checkRecordPassword(_ sender: UIButton) {
	}
	
}
