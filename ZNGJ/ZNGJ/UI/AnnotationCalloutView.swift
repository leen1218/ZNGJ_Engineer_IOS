//
//  AnnotationCalloutView.swift
//  ZNGJ
//
//  Created by HuangBing on 1/21/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class AnnotationCalloutView : UIView {
    var orderId: Int!
    var currentOrder: Order!
    func setOrderId(_ orderId: Int) {
        self.orderId = orderId
        for item in UserModel.SharedUserModel().orderManager.unreservedOrders {
            if item.orderId == orderId {
                currentOrder = item
                break
            }
        }
        // currently add a uilabel, for testing purpose
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 80))
        label.text = "智能管家"
        self.addSubview(label)
        
        // tap event handling
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        Logger.logToConsole("annotation calloutview tapped !!!")
    }
    
    
}
