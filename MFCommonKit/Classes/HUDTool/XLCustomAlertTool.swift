//
//  XLCustomAlertTool.swift
//  XJXN
//
//  Created by simple on 2018/12/19.
//  Copyright © 2018年 simple. All rights reserved.
//

public class XLCustomAlertTool {
    
    /// 自定义弹出框
    class func showCustomAlert(containerView:UIView? = nil, contentView: UIView, animator: JXPopupViewAnimationProtocol? = JXPopupViewZoomInOutAnimator(),backStyle: JXPopupViewBackgroundStyle = .solidColor, blurStyle: UIBlurEffect.Style = .light, backColor:UIColor = UIColor.black.withAlphaComponent(0.3)) {
        var container:UIView! = containerView
        if containerView == nil {
            guard let appdelegate = UIApplication.shared.delegate else {
                return
            }
            guard let window = appdelegate.window ?? nil else {
                return
            }
            
            container = window
        }
        let popupView = JXPopupView(containerView: container, contentView: contentView, animator: animator!)
        //配置交互
        popupView.isDismissible = true
        popupView.isInteractive = true
        //可以设置为false，再点击弹框中的button试试？
        //        popupView.isInteractive = false
        popupView.isPenetrable = false
        //- 配置背景
        popupView.backgroundView.style = backStyle
        popupView.backgroundView.blurEffectStyle = blurStyle
        popupView.backgroundView.color = backColor
        popupView.display(animated: true, completion: nil)
        
    }
    
    /// 中间提示框 取消 + 确定
    class func showSystemCenterAlert(cancelTitle:String?=nil,title:String?, alertArray:[String]?, titleColor: UIColor = UIColor.sk_hexColor("#333333"), touchCallback:@escaping (Int) -> ()) {
        
        let alertVC = UIAlertController.init(title: "", message: title, preferredStyle: .alert)
        
        for (k,v) in (alertArray?.enumerated())! {
            let action = UIAlertAction.init(title: v, style: .default, handler: { (action) in
                touchCallback(k)
            })
            alertVC.addAction(action)
            action.setValue(titleColor, forKey: "titleTextColor")
        }
        
        let cancel = UIAlertAction.init(title: (cancelTitle ?? "取消"), style: .cancel, handler: { (action) in
            
        })
        alertVC.addAction(cancel)
        cancel.setValue(UIColor.sk_hexColor("#333333"), forKey: "titleTextColor")
        
        SKTopViewController.topViewController()?.present(alertVC, animated: true, completion: {
        })
    }
    
    /// 中间提示框 取消 + 确定
    class func showSystemCenterNoCancelAlert(title:String?, alertArray:[String]?, touchCallback:@escaping (Int) -> ()) {
        
        let alertVC = UIAlertController.init(title: "", message: title, preferredStyle: .alert)
        
        for (k,v) in (alertArray?.enumerated())! {
            
            alertVC.addAction(UIAlertAction.init(title: v, style: .default, handler: { (action) in
                touchCallback(k)
            }))
            
        }
        
        SKTopViewController.topViewController()?.present(alertVC, animated: true, completion: {
        })
    }
    
    /// 中间提示框   提示
    class func showSystemCenterTileAlert(title:String?,titleSize:UIFont? = UIFont.sk_font(size: 16), titleColor: UIColor? = .black,message:String? = nil,messageFont:UIFont? = UIFont.sk_font(size: 14),messageColor:UIColor? = .lightGray, alertArray:[String]?, blankDismiss:Bool = true, touchCallback:@escaping (Int) -> ()) {
        
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        for (k,v) in (alertArray?.enumerated())! {
            
            alertVC.addAction(UIAlertAction.init(title: v, style: .default, handler: { (action) in
                touchCallback(k)
            }))
        }
        guard let titleStr = title else {
            SKTopViewController.topViewController()?.present(alertVC, animated: true, completion: {
                if blankDismiss == false { return }
                alertVC.blankDismiss()
            })
            return }
        
        let titleAttrStr = NSAttributedString.init(string: titleStr, attributes: [NSAttributedString.Key.foregroundColor:titleColor!,NSAttributedString.Key.font:titleSize!])
        alertVC.setValue(titleAttrStr, forKey: "attributedTitle")
        
        guard let messageStr = message else {
            SKTopViewController.topViewController()?.present(alertVC, animated: true, completion: {
                if blankDismiss == false { return }
                alertVC.blankDismiss()
            })
            return }
        
        let messageAttrStr = NSAttributedString.init(string: messageStr, attributes: [NSAttributedString.Key.foregroundColor:messageColor!,NSAttributedString.Key.font:messageFont!])
        alertVC.setValue(messageAttrStr, forKey: "attributedMessage")
        
        SKTopViewController.topViewController()?.present(alertVC, animated: true, completion: {
            if blankDismiss == false { return }
            alertVC.blankDismiss()
        })
    }
    
    class func ifNeededShowNewAlert() -> Bool {
        guard let topVc = SKTopViewController.topViewController() else { return true}
        if !topVc.isKind(of: UIAlertController.self) {
            return true
        }
        return false
    }
}

