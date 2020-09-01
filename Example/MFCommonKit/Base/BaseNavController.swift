//
//  BaseNavController.swift
//  Base
//
//  Created by MFun on 2019/6/3.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit
import MFCommonKit
 
class BaseNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNav()
        
    }    
    func configNav() {
        
        navigationBar.barTintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: PingFangSCMedium, size: CGFloat(16)) ?? UIFont.sk_font(size: 16)]
        
        
        navigationBar.tintColor = UIColor.black
        navigationBar.backgroundColor = UIColor.white
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true

            //一层显示首页标题 其他显示返回
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "back")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(popViewController(animated:)))

//            if let vc = (viewController as? BaseViewController){
//                vc.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:SKDefaultsImg.backNav, style: .done, target: self, action: #selector(popViewController(animated:)))
//            }
//
//            if let vc = (viewController as? UITabBarController){
//                vc.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:SKDefaultsImg.backNav, style: .done, target: self, action: #selector(popViewController(animated:)))
//            }
//
//            if let vc = (viewController as? SKInjectWebViewController){
//                vc.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:SKDefaultsImg.backNav, style: .done, target: self, action: #selector(popViewController(animated:)))
//            }
            
        }
        super.pushViewController(viewController, animated: true)
    }
    
}

