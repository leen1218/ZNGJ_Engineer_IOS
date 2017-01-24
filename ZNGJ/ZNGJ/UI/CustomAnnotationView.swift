//
//  CustomAnnotationView.swift
//  ZNGJ
//
//  Created by HuangBing on 1/23/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class CustomAnnotationView : MAPinAnnotationView, UIPopoverPresentationControllerDelegate {
    var calloutView: AnnotationCalloutView!
    fileprivate static let calloutWidth = 200
    fileprivate static let calloutHeight = 70
    weak var vc: UIViewController!
    
    var orderIds: [Int] = []
    
    override init(annotation: MAAnnotation, reuseIdentifier: String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleAnnotationViewTap(sender:))))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    func setOrderId(_ orderIds: [Int], _ vc: UIViewController) {
        self.orderIds = orderIds
        self.vc = vc
    }
    
    func handleAnnotationViewTap(sender: UITapGestureRecognizer) {
        Logger.logToConsole("handleAnnotationViewTap")
        // we should present the callout view here with popover
        let calloutView = AnnotationCalloutView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        
        // Present the view controller using the popover style.
        let vc = UIViewController.init()
        vc.preferredContentSize = CGSize.init(width: 100, height: 100)
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.view.addSubview(calloutView)
        
        self.vc.present(vc, animated: true, completion: nil)
        let presentationController = vc.popoverPresentationController
        presentationController?.permittedArrowDirections = .any
        presentationController?.sourceView = self
        presentationController?.sourceRect = self.frame
        presentationController?.delegate = self
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        if self.isSelected == selected {
//            return
//        }
//        if selected {
//            if self.calloutView == nil {
//                self.calloutView = AnnotationCalloutView.init(frame: CGRect.init(x: 0, y: 0, width: CustomAnnotationView.calloutWidth, height: CustomAnnotationView.calloutHeight))
//                self.calloutView.center = CGPoint.init(x: self.bounds.size.width / 2.0 + self.calloutOffset.x, y: -self.calloutView.bounds.size.height / 2.0 + self.calloutOffset.y)
//                self.calloutView.setOrderId(self.orderIds)
//                self.calloutView.isUserInteractionEnabled = true
//            }
//            
//            self.addSubview(self.calloutView)
//        } else {
//            self.calloutView.removeFromSuperview()
//            
//            // navigate to detail
//            var topVC = UIApplication.shared.keyWindow?.rootViewController
//            while((topVC!.presentedViewController) != nil) {
//                topVC = topVC!.presentedViewController
//            }
//            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC")
//            if let newVC = vc as? OrderViewController {
//                newVC.order = UserModel.SharedUserModel().orderManager.getUnreservedOrdersFromIds(self.orderIds)[0]                
//                self.vc.navigationController?.pushViewController(newVC, animated: true)
//            }
//            
//        }
//        super.setSelected(selected, animated: animated)
//    }
    
}
