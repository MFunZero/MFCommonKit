//
//  SKTheme.swift
//  Base
//
//  Created by MFun on 2019/6/3.
//  Copyright © 2019 MFun. All rights reserved.
//

import Foundation
import UIKit

class SKTheme {
    /// 主题颜色：navBar
    static let mainColor: UIColor = UIColor.sk_hexColor("#F8D750")
    /// 主题渐变颜色
    static let mainGradientImage: UIImage? = UIImage.createImageWithColors(colors: [UIColor.sk_hexColor("#FFE476"),UIColor.sk_hexColor("#F8D750")])
    /// 主题颜色：tabBar
    static let tabBarTintColor: UIColor = UIColor.sk_hexColor("#9867AC")
 
    /// 主题颜色：navBar
    static let mainColorDark: UIColor = UIColor.sk_hexColor("#3685ED")
    /// 背景颜色
    static let bgColor: UIColor = UIColor.sk_hexColor("#F6F5F8")
//    @available(iOS 13.0, *)
//    static let bgColor: UIColor = UIColor { (trainCollection) -> UIColor in
//
//        if trainCollection.userInterfaceStyle == .dark {
//            return UIColor.black
//        } else {
//            return UIColor.sk_hexColor("#F6F5F8")
//        }
//    }

    /// 提示颜色
    static let tipsColor: UIColor = UIColor.sk_hexColor("#FFB800")
    /// 错误、警告
    static let errorColor: UIColor = UIColor.sk_hexColor("#FF5722")
    /// 深色
    static let darkColor: UIColor = UIColor.sk_hexColor("#393D49")
    /// 选中颜色
    static let selectedColor: UIColor = UIColor.sk_hexColor("#5FB878")
    ///
    static let disabledColor: UIColor = UIColor.sk_hexColor("#c2c2c2")
    /// navBar tintColor
    static let tintColor_NavBar: UIColor = UIColor.sk_hexColor("#989898")
    /// NavBar Title
    static let titleColorH1: UIColor = UIColor.black
    /// headerView的颜色
    static let titleColorH2: UIColor = UIColor.black
    ///
    static let titleColorH3: UIColor = UIColor.sk_hexColor("#4A4A4A")
    /// 日期weekbar字体效果
    static let titleColorH4: UIColor = UIColor.sk_hexColor("#9B9B9B")
    ///置灰效果
    static let titleColorH5: UIColor = UIColor.sk_hexColor("##C9C9C9")
    /// 分隔线颜色
    static let seperatorColor: UIColor = UIColor.sk_hexColor("#E8E8E8")
    
    /// 默认边际距离
    static let defaultEdge: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)

    /// 默认用户头像
    static let defaultAvatar: UIImage = UIImage(named: "avatar")!
    
    ///
    static let defaultPlaceHolderImg: UIImage = UIImage(named: "defaultPlaceHolderImg")!
    
    ///navbar等标题字体字号
    static let sk_Font_Big: UInt32 = 16
    ///正文
    static let sk_Font_Medium: UInt32 = 12
    ///小标题
    static let sk_Font_Small: UInt32 = 12    
    
}

