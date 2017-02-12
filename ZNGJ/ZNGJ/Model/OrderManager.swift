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
	
	var pendingOrder : Order? = nil
	
	func addOrderToUnreservedList(order:Order)
	{
		self.unreservedOrders.append(order)
	}
	func removeOrderFromUnreservedList(order:Order)
	{
		for i in 0 ..< self.unreservedOrders.count {
			if self.unreservedOrders[i].orderId == order.orderId {
				self.unreservedOrders.remove(at: i)
				break;
			}
		}
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
