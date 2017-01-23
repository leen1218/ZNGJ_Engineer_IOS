//
//  CustomAnnotationView.swift
//  ZNGJ
//
//  Created by HuangBing on 1/23/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class CustomAnnotationView : MAPinAnnotationView {
    var calloutView: AnnotationCalloutView!
    fileprivate static let calloutWidth = 200
    fileprivate static let calloutHeight = 70
    
    var orderIds: [Int] = []
    
    func setOrderId(_ orderIds: [Int]) {
        self.orderIds = orderIds
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isSelected == selected {
            return
        }
        if selected {
            if self.calloutView == nil {
                self.calloutView = AnnotationCalloutView.init(frame: CGRect.init(x: 0, y: 0, width: CustomAnnotationView.calloutWidth, height: CustomAnnotationView.calloutHeight))
                self.calloutView.center = CGPoint.init(x: self.bounds.size.width / 2.0 + self.calloutOffset.x, y: -self.calloutView.bounds.size.height / 2.0 + self.calloutOffset.y)
                self.calloutView.setOrderId(self.orderIds)
                self.calloutView.isUserInteractionEnabled = true
            }
            
            self.addSubview(self.calloutView)
        } else {
            self.calloutView.removeFromSuperview()
            
            // navigate to detail
            var topVC = UIApplication.shared.keyWindow?.rootViewController
            while((topVC!.presentedViewController) != nil) {
                topVC = topVC!.presentedViewController
            }
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC")
            if let newVC = vc as? OrderViewController {
                newVC.order = UserModel.SharedUserModel().orderManager.getUnreservedOrdersFromIds(self.orderIds)[0]
                topVC?.present(vc, animated: true, completion: nil)
            }
            
        }
        super.setSelected(selected, animated: animated)
    }
    
}
