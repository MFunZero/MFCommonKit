//
//  UITabBarIteExtension.swift
//  KindergartenPApplication
//
//  Created by iOS-dev on 2020/5/19.
//  Copyright © 2020 iMFun.com. All rights reserved.
//

import Foundation


public extension UITabBar {
    
    /// 显示红点
    /// - Parameters:
    ///   - index: 控制器index
    ///   - tabbarNum: tabBarItem总数量
    func showDotBadge(index: Int, tabbarNum: Int){
        self.hideDotBadge()
        let badgeView = UIView()
        badgeView.cornerRadius = 4
        badgeView.tag = 999
        badgeView.clipsToBounds = true
        badgeView.backgroundColor = UIColor.red
        let tabFrame = self.frame

        let percentX: CGFloat = CGFloat(index) + 0.55
        let tabBarButtonW = tabFrame.width/CGFloat(tabbarNum)
        let x = percentX*tabBarButtonW;
        let y = 0.1*tabFrame.height;
        //10为小红点的高度和宽度
        badgeView.frame = CGRect(x: x, y: y, width: 8, height: 8)
        
        self.addSubview(badgeView)
        self.bringSubviewToFront(badgeView)
    }
    
    func hideDotBadge(){
        self.viewWithTag(999)?.removeFromSuperview()
    }
    
}
