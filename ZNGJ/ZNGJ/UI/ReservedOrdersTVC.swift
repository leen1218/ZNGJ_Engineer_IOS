//
//  ReservedOrdersTVC.swift
//  ZNGJ
//
//  Created by en li on 17/1/17.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation

class ReservedOrdersTVC: UITableViewController {
	
	var orders: [Order]!
	
	override func viewDidLoad() {
	}
	
	
// Data Source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.orders.count
	}
	
// View
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellId = "orderinfocell"
		var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
		
		if cell == nil
		{
			print("can not find cell with id = " + cellId)
			cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
		}
		
		// configure cell
		cell!.textLabel!.text = "Order ID: " + String(self.orders[indexPath.row].orderId)
		cell!.detailTextLabel!.text = self.orders[indexPath.row].orderAddress
		
		return cell!
	}
	
// Cell Segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if sender is UITableViewCell {
			if segue.identifier == "showOrderDetail" && segue.destination is OrderViewController {
				let destVC: OrderViewController = segue.destination as! OrderViewController
				let cellIndex: IndexPath? = self.tableView.indexPath(for: sender as! UITableViewCell)
				guard cellIndex != nil else {
					print("所选订单为空!")
					return
				}
				destVC.order = self.orders[cellIndex!.row]
			}
		}
	}
	
}
