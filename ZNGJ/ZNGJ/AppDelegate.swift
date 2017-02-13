//
//  AppDelegate.swift
//  ZNGJ
//
//  Created by en li on 16/12/23.
//  Copyright © 2016年 en li. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		AMapServices.shared().apiKey = "3d224d25b983d14ed0a09d243150457c"
		
		if (launchOptions != nil) {
			if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String : Any] {
				if let order_data = notification["order_info"] as? [String : Any] {
					// 添加到pending order，界面打开时添加到界面上面
					UserModel.SharedUserModel().orderManager.pendingOrder = Order.init(data: order_data)
					// 消息清空
					application.applicationIconBadgeNumber = 0
				}
			}
		}
		return true
	}
	
	// Get Device Token
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		// Convert token to string
		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
		
		// Print it to console
		print("APNs device token: \(deviceTokenString)")
		// 2. 向服务器发送登录请求
		let request:ZNGJRequest = ZNGJRequestManager.shared().createRequest(ENUM_REQUEST_REGISTER_DEVICE_TOKEN)
		var cellphone:String? = UserDefaults.standard.string(forKey: "username")
		if (cellphone == nil) {
			cellphone = "13616549781"
		}
		let params:Dictionary<String, String> = ["cellphone":cellphone!, "devicetoken":deviceTokenString]
		request.params = params
		request.handler = nil
		request.start()
	}
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print(error)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
	{
		if let order_data = userInfo["order_info"] as? [String : Any] {
			let order = Order.init(data: order_data)
			UserModel.SharedUserModel().orderManager.addOrderToUnreservedList(order: order)
			
			// Try to display popover on the top view controller
			let rootVC:MainTBViewController = self.window?.rootViewController as! MainTBViewController
			let rootNVC:UINavigationController? = rootVC.selectedViewController as? UINavigationController
			if let topVC = rootNVC?.topViewController {
				let orderInfo = order.orderProduction + " " + order.orderReservedDate
				let okaction = UIAlertAction(title: "查看", style: .default, handler: {
					// 跳转到订单详细界面
					action in
					let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC")
					if let newVC = vc as? OrderViewController {
						newVC.order = order
						topVC.navigationController?.pushViewController(vc, animated: true)
					}
				})
				showAlert(title: "新的订单", message: orderInfo, parentVC: topVC, okAction: okaction, cancel: true)
			}
		}
		// 消息清空
		application.applicationIconBadgeNumber = 0
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

