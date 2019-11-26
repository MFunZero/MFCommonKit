//
//  UIColorExtension.swift
//  liangzhan
//
//  Created by simple on 2018/11/24.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit

extension UIColor {    
    /// 添加计算型属性生成随机颜色
    class var ramdomColor: UIColor {
        return UIColor(R: arc4random_uniform(256),
                       G: arc4random_uniform(256),
                       B: arc4random_uniform(256))
    }    
    /// 便利构造函数
    convenience init(R: UInt32, G: UInt32, B: UInt32, A: CGFloat = 1.0) {
        self.init(red: CGFloat(R) / 255.0,
                  green: CGFloat(G) / 255.0,
                  blue: CGFloat(B) / 255.0,
                  alpha: A)
    }    
    /// 利用十六进制字符串构造颜色
    ///
    /// - Parameter hexString: 颜色十六进制字符
    /// - Returns: 颜色值
    class func sk_hexColor(_ hexString: String) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 { return UIColor.black }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        
        if cString.count != 6 { return UIColor.black }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(R: r, G: g, B: b)
    }
    
}
