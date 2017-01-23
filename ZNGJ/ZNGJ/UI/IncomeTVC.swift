//
//  IncomeTVC.swift
//  ZNGJ
//
//  Created by en li on 17/1/23.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation

class IncomeTVC: UITableViewController {
	
	var completedOrders: [Order]!
	
	override func viewDidLoad() {
	}
	
	
	// Data Source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.completedOrders.count
	}
	
	// View
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellId = "orderpaymentcell"
		var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
		
		if cell == nil
		{
			print("can not find cell with id = " + cellId)
			cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
		}
		
		// configure cell
		cell!.textLabel!.text = self.completedOrders[indexPath.row].orderProduction
		cell!.detailTextLabel!.text = String(self.completedOrders[indexPath.row].orderPayment)
		
		return cell!
	}
}
