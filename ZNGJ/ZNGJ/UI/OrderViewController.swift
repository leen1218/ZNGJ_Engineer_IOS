//
//  OrderViewController.swift
//  ZNGJ
//
//  Created by en li on 17/1/17.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation
class OrderViewController: UIViewController {
	
	
	@IBOutlet weak var orderNO: UILabel!
	@IBOutlet weak var orderStatus: UILabel!
	@IBOutlet weak var bookingDate: UILabel!
	@IBOutlet weak var contact: UILabel!
	@IBOutlet weak var cellphone: UILabel!
	@IBOutlet weak var address: UILabel!
	@IBOutlet weak var reservedDate: UILabel!
	@IBOutlet weak var production: UILabel!
	
	@IBOutlet weak var acceptOrderBtn: UIButton!
	
	var order: Order!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//
		self.updateUI()
	}
	
	func updateUI()
	{
		self.orderNO.text = order.orderNo
		self.orderStatus.text = order.orderStatus
		self.bookingDate.text = order.orderBookingDate
		self.contact.text = order.orderContact
		self.cellphone.text = order.orderCellPhone
		self.address.text = order.orderAddress
		self.reservedDate.text = order.orderReservedDate
		self.production.text = order.orderProduction
		
		if self.order.orderStatus == "未接单"
		{
			self.acceptOrderBtn.isHidden = false
		} else {
			self.acceptOrderBtn.isHidden = true
		}
	}
	
	@IBAction func acceptOrder(_ sender: UIButton) {
		
	}
	
}
