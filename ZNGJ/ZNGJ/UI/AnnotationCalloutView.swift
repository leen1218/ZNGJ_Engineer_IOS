//
//  AnnotationCalloutView.swift
//  ZNGJ
//
//  Created by HuangBing on 1/21/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class AnnotationCalloutView : UIView {
    var orderIds: [Int] = []
	var orderAddress: String?
    weak var delegate: CalloutViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
	func setOrderId(_ orderIds: [Int], address: String) {
        self.orderIds = orderIds
		self.orderAddress = address
		
		// 订单地址
		let label = UILabel.init()
		label.text = self.orderAddress
		label.frame = CGRect.init(x: 0, y: 10, width: self.frame.width, height: 15)
		label.textAlignment = .center
		label.font = UIFont.boldSystemFont(ofSize: 17)
		self.addSubview(label)
		
		// 订单个数
		if self.orderIds.count > 1 {
			let label = UILabel.init()
			label.text = "该区域共有" + String(self.orderIds.count) + "个订单"
			label.frame = CGRect.init(x: 0, y: 30, width: self.frame.width, height: 15)
			label.textAlignment = .center
			label.font = UIFont.boldSystemFont(ofSize: 13)
			self.addSubview(label)
		} else {
			// 订单任务
			let label = UILabel.init()
			label.text = UserModel.SharedUserModel().orderManager.getOrderByID(orderID: self.orderIds[0])?.orderProduction
			label.frame = CGRect.init(x: 0, y: 25, width: self.frame.width, height: 15)
			label.textAlignment = .center
			label.font = UIFont.boldSystemFont(ofSize: 17)
			self.addSubview(label)
		}
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        Logger.logToConsole("annotation calloutview tapped !!!")
        
        // here we goto the detail order view
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC")
        if let newVC = vc as? OrderViewController {
            newVC.order = UserModel.SharedUserModel().orderManager.getUnreservedOrdersFromIds(self.orderIds)[0]
            delegate.dismissVC(animated: false, completion: nil)
            delegate.pushViewController(newVC, animated: true)
            
        }
    }
}

public protocol CalloutViewDelegate : NSObjectProtocol {
    func presentVC(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismissVC(animated: Bool, completion: (() -> Void)?)
    func pushViewController(_ viewcontroller: UIViewController, animated: Bool)
    
}

