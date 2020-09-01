//
//  UIFontExtension.swift
//  liangzhan
//
//  Created by simple on 2018/11/25.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit
// 主题字体
//let HeitiSC = "Heiti SC"
/// 中号
public let PingFangSCMedium = "PingFangSC-Medium"
/// 常规体 ->  默认标记为苹果默认字体
public let PingFangSCRegular = "PingFang-SC-Regular"
///  英文字体
//let DINCondensedBold = "DINCondensed-Bold"
//let HelveticaBold = "Helvetica-Bold"      // 英文粗体
public let PingFangTCLight = "PingFangTC-Light" // 极细
//let Helvetica = "Helvetica" // 极细
public let PingFangSCSemibold = "PingFangSC-Semibold" // 巨粗

//16
//12
//10

// MARK: - 根据机型不同改变系统字体大小
public extension UIFont {
    
    class func sk_font(size: UInt32, name: String = PingFangSCRegular) -> UIFont {    
        var newSize:CGFloat = CGFloat(size)
        
        if UIScreen.sk_ScreenWidth() > 375 {
            newSize += 2
        } else if UIScreen.sk_ScreenWidth() < 375 {
            newSize -= 2
        }
        guard let font = UIFont(name:name, size: newSize) else {
            return UIFont(name:name, size: newSize) ?? UIFont()
        }
        return font
    }
    
    class func skLogAllFontName(){
        let fontAll = UIFont.familyNames
        for sub in fontAll {
            SKLog("字体库----\(sub)")
            let subTitle = UIFont.fontNames(forFamilyName: sub)
            SKLog("字体-----\(subTitle)")
        }
    }
    
}
