//
//  BaseTabBarController.swift
//  Base
//
//  Created by MFun on 2019/6/3.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit
import MFCommonKit

let SK_NotificationName_NeedLogin = "SK_NotificationName_NeedLogin"
let SK_NotificationName_NeedRefresh = "SK_NotificationName_NeedRefresh"

class BaseTabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.layoutSubviews()
    }    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        NotificationCenter.default.addObserver(self, selector: #selector(needLogin(notify:)), name: NSNotification.Name(rawValue: SK_NotificationName_NeedLogin), object: nil)

        setupChildrensViewController()
//        SKVersionTool.checkUpdate()
//        let item = tabBar.items?[2]
//        item?.badgeValue = ""
//        item?.badgeColor = UIColor.red
//        tabBar.showDotBadge(index: 2, tabbarNum: 4)
         
        
    }
    func setupChildrensViewController() {
        // MARK: -TODO
        let array = [
            ["clsName":NSStringFromClass(BaseTabBarController.self),"title":"班级","img":"home"],
            ["clsName":NSStringFromClass(BaseTabBarController.self),"title":"书库","img":"modules"],
             ["clsName":NSStringFromClass(BaseTabBarController.self),"title":"消息","img":"msg"],
            ["clsName":NSStringFromClass(BaseTabBarController.self),"title":"我的","img":"mine"]
        ]
        
        var childVCs = [UIViewController]()
        for dict in array {
            childVCs.append(setupSingleChildController(configDic: dict))
        }
        viewControllers = childVCs
        
    }    
    func setupSingleChildController(configDic: [String: String]) -> UIViewController {
        /// 对参数进行守护
        guard  let title = configDic["title"],
            let className = configDic["clsName"],
            let tabbarItemImageName = configDic["img"],
            let childControllerClass = NSClassFromString(className) as?UIViewController.Type else {
                return UIViewController()
        }
        
        /// 初始化子控制器
        let childVC = childControllerClass.init()
        //设置标题
//        childVC.navigationItem.title = title
        //设置默认背景
        //        childVC.tabBarItem.image = nil
        childVC.tabBarItem.image = UIImage(named: tabbarItemImageName)?.withRenderingMode(.alwaysOriginal)
        //设置选中背景
        childVC.tabBarItem.selectedImage = UIImage(named: tabbarItemImageName + "_Selected")?.withRenderingMode(.alwaysOriginal)
        //设置字体属性
        //        childVC.tabBarItem.title = nil
        childVC.tabBarItem.title = title
        childVC.tabBarItem.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.sk_hexColor("#CCCCCC")], for: .selected)
        childVC.tabBarItem.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor:UIColor.clear], for: .normal)
//       childVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
//        childVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.sk_font(size: 11)], for: .normal)
        
        let nav = BaseNavController.init(rootViewController: childVC)
        
        return nav
        
    }
    
    static func showBadge(show: Bool,index: Int ) {
        guard let tabBarVC = SKTopViewController.topViewController()?.tabBarController else { return }
        if show {
            tabBarVC.tabBar.showDotBadge(index: index, tabbarNum: 4)
        } else {
            tabBarVC.tabBar.hideDotBadge()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SK_NotificationName_NeedLogin), object: nil)
    }
    
}

extension BaseTabBarController: UITabBarControllerDelegate{    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         
    }
    /// 控制navBar中包含的ViewController 设置隐藏NavBar情况时push操作返回出现黑色区域
    /// - Parameters:
    ///   - tabBarController:
    ///   - viewController:
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let child = viewController.children.first as? ViewController {
            // 当viewApear是来自tabBar点击时 navBar隐藏不用动画方式
//            child.isTabBarClicked = true
        } else if let child = viewController.children.first as? ViewController {
            // 当viewApear是来自tabBar点击时 navBar隐藏不用动画方式
//                       child.isTabBarClicked = true
        }
        return true
    }
}

extension BaseTabBarController {
    @objc func needLogin(notify: Notification) {
        RoutePageTool.showLoginVCWithRoot()
    }    
}
