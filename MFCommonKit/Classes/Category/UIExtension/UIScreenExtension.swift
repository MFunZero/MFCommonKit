//
//  UIScreenExtension.swift
//  liangzhan
//
//  Created by simple on 2018/11/25.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit

extension UIScreen {    
    class func sk_ScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    class func sk_ScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    class func sk_ScreenScale() -> CGFloat {
        return UIScreen.main.scale
    }
    
}
