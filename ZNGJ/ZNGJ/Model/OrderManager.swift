//
//  OrderManager.swift
//  ZNGJ
//
//  Created by HuangBing on 1/17/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class OrderManager {
    var orderList: [Order] = []
    
    init() {
    }
	
	var unreservedOrders: [Order] = []
	var completedOrders: [Order] = []
	var uncompletedOrders: [Order] = []
	
	func addOrderToUnreservedList(order:Order)
	{
		self.unreservedOrders.append(order)
	}
	func addOrderToUnCompletedList(order:Order)
	{
		self.uncompletedOrders.append(order)
	}
	func addOrderToCompletedList(order:Order)
	{
		self.completedOrders.append(order)
	}
	
	func clearOrders()
	{
		self.completedOrders.removeAll()
		self.uncompletedOrders.removeAll()
		self.unreservedOrders.removeAll()
	}
    
    func getUnreservedOrdersFromIds(_ orderIds: [Int]) -> [Order] {
        var retOrders: [Order] = []
        for orderId in orderIds {
            for order in unreservedOrders {
                if (orderId == order.orderId) {
                    retOrders.append(order)
                    break;
                }
            }
        }
        return retOrders
    }
}
