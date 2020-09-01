//
//  UIVIewControllerExtension.swift
//  liangzhan
//
//  Created by simple on 2018/11/25.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit


public extension UIViewController {    
    /// 获取tabbar高度
    var sk_tabbarHeight: CGFloat {
        return self.tabBarController?.tabBar.bounds.height ?? 0
    }    
    /// 获取导航栏加状态栏高度
    var sk_navHeight: CGFloat {
        guard let navHeight = self.navigationController?.navigationBar.bounds.height else {
            return sk_statusBarHeight
        }
        return  navHeight + sk_statusBarHeight
    }    
    /// 获取状态栏高度
    var sk_statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
}

