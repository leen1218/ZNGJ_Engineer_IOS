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
    
    func setOrderId(_ orderIds: [Int]) {
        self.orderIds = orderIds
        
        // currently add a uilabel, for testing purpose
//        let label = UILabel.init(frame: self.bounds)
//        label.text = "智能管家"
//        self.addSubview(label)
        
        // tap event handling
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
//        self.addGestureRecognizer(tap)
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

