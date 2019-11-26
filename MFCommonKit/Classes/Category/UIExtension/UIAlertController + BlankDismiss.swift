//
//  UIAlertController + BlankDismiss.swift
//  XJXN
//
//  Created by simple on 2018/12/21.
//  Copyright © 2018年 simple. All rights reserved.
//
import Foundation
import UIKit

extension UIAlertController {    
    /// 点击空白处消失
    func blankDismiss(){
        
        let viewsArray = UIApplication.shared.keyWindow!.subviews
        if viewsArray.count > 0 {
            let backView = viewsArray.last
            backView?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapBlank))
            backView?.addGestureRecognizer(tap)
        }
    }    
    @objc fileprivate func tapBlank(){
        self.dismiss(animated: true, completion: nil)
    }
}
