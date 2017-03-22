//
//  MainTBViewController.swift
//  ZNGJ
//
//  Created by en li on 17/1/3.
//  Copyright © 2017年 en li. All rights reserved.
//

import UIKit

class MainTBViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

		//创建tabbar的子控制器
		self.creatSubViewControllers()
    }
	
	func creatSubViewControllers(){
		let weixiu_item : UITabBarItem = self.tabBar.items![0]
		weixiu_item.title = "维修"
		weixiu_item.image = UIImage(named: "tabweixiu30")
		weixiu_item.selectedImage = UIImage(named: "tabweixiu30")
		
		let wo_item : UITabBarItem = self.tabBar.items![1]
		wo_item.title = "我"
		wo_item.image = UIImage(named: "tabuser30")
		wo_item.selectedImage = UIImage(named: "tabuser30")
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
