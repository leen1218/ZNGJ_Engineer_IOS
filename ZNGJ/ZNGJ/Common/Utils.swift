//
//  Utils.swift
//  ZNGJ
//
//  Created by HuangBing on 1/20/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation
import UIKit

func synchronizd(_ lock: AnyObject, closure:()->()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock);
}

func showAlert(title: String, message : String, parentVC: UIViewController, okAction: UIAlertAction?, cancel: Bool = false)
{
	let alertController = UIAlertController(title: title,
	                                        message: message,
	                                        preferredStyle: .alert)
	if cancel {
		let defaultCancelAction = UIAlertAction(title: "取消", style: .default, handler: {
			action in
		})
		alertController.addAction(defaultCancelAction)
	}
	if okAction == nil {
		let defaultOkAction = UIAlertAction(title: "确定", style: .default, handler: {
			action in
		})
		alertController.addAction(defaultOkAction)
	} else {
		alertController.addAction(okAction!)
	}
	parentVC.present(alertController, animated: true, completion: nil)
}
