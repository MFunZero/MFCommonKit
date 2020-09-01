//
//  SKTopViewController.swift
//  Base
//
//  Created by MFun on 2019/6/3.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit
 
public class SKTopViewController: NSObject {
    @objc public class func topViewController() -> UIViewController? {
        return self.topViewControllerWithRootViewController(viewController: self.getCurrentWindow()?.rootViewController)
    }    
    private class func topViewControllerWithRootViewController(viewController: UIViewController?) -> UIViewController? {
        if viewController == nil {
            return nil
        }
        if viewController?.presentedViewController != nil {
            return self.topViewControllerWithRootViewController(viewController:viewController?.presentedViewController!)
        } else if viewController?.isKind(of: UITabBarController.self) == true {
            guard let tabVC = viewController as? UITabBarController else {
                return nil
            }
            return self.topViewControllerWithRootViewController(viewController: tabVC.selectedViewController)
        } else if viewController?.isKind(of: UINavigationController.self) == true {
            guard let navVC = viewController as? UINavigationController else {
                return nil
            }
            return self.topViewControllerWithRootViewController(viewController:navVC.visibleViewController)
        } else {
            return viewController
        }
    }    
    private class func getCurrentWindow() -> UIWindow? {
        
        var window: UIWindow? = UIApplication.shared.keyWindow
        
        if window?.windowLevel != UIWindow.Level.normal {
            for tempWindow in UIApplication.shared.windows where tempWindow.windowLevel == UIWindow.Level.normal {
                    window = tempWindow
            }
        }
        return window
    }
}
