//
//  RouteTool.swift
//  KindergartenPApplication
//
//  Created by iOS-dev on 2019/12/13.
//  Copyright © 2019 iOS-dev. All rights reserved.
//

import Foundation

class RoutePageTool {
    
    
    static func showLoginVCWithRoot(){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let view = appdelegate.window else {
            return
        }
        let mainVC = ViewController()
        view.rootViewController = mainVC
    }
    
    static func showMainVCWithRoot(){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let view = appdelegate.window else {
            return
        }
        
        let mainVC = BaseTabBarController()
        view.rootViewController = mainVC
          
    }
    
}
