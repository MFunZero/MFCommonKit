//
//  CommonExtension.swift
//  KindergartenTApplication
//
//  Created by iOS-dev on 2020/1/3.
//  Copyright © 2020 iMFun.com. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    // 文字居于图片下方居中
    func adjustCenterImgTitle() {
        guard let titleLabel = self.titleLabel, let img = self.imageView?.image  else { return }
        self.imageEdgeInsets = UIEdgeInsets(top: -titleLabel.height-5, left: titleLabel.width, bottom: 5, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: img.size.height+5, left: -img.size.width, bottom: 0, right: 0)
        
    }
}

public extension String {
    
    /// 数字、字母、汉字
    func isLegalInput()->Bool{
        
        var result = ""
        // - 1、创建规则
        let pattern1 = "[^a-zA-Z0-9\\u4E00-\\u9FA5_]"
        //        let pattern1 = "^[a-zA-Z\\u4e00-\\u9fa5][a-zA-Z0-9\\u4e00-\\u9fa5]$"
        // - 2、创建正则表达式对象
        let regex1 = try! NSRegularExpression(pattern: pattern1, options: NSRegularExpression.Options.caseInsensitive)
        // - 3、开始匹配A
        let res = regex1.matches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, self.count))
        // 输出结果
        for checkingRes in res {
            result = result + (self as NSString).substring(with: checkingRes.range)
        }
        if result == self{
            return true
        }else{
            return false
        }
    }
    
    /// 数字、字母
    func isLegalPwdInput()->Bool{
        
        var result = ""
        // - 1、创建规则
        let pattern1 = "^[a-z_A-Z0-9-\\.!@#\\$%\\\\^&\\*\\)\\(\\+=\\{\\}\\[\\]\\/\",'<>~\\·`\\?:;|]+$"
        //        let pattern1 = "^[a-zA-Z\\u4e00-\\u9fa5][a-zA-Z0-9\\u4e00-\\u9fa5]$"
        // - 2、创建正则表达式对象
        let regex1 = try! NSRegularExpression(pattern: pattern1, options: NSRegularExpression.Options.caseInsensitive)
        // - 3、开始匹配A
        let res = regex1.matches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, self.count))
        // 输出结果
        for checkingRes in res {
            result = result + (self as NSString).substring(with: checkingRes.range)
        }
        if result == self{
            return true
        }else{
            return false
        }
    }
    
}

extension UIButton {
    func adjustEdgeInsets() {
        guard let titleLabel = self.titleLabel, let img = self.imageView?.image, let text = self.currentTitle else { return }
        //        if text.count > 5 {
        //            let subString = String(text.prefix(5))
        //            self.setTitle("\(subString)...", for: UIControl.State.selected)
        //        } else {
        //            self.setTitle(text, for: UIControl.State.selected)
        //        }
        let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font : titleLabel.font ?? UIFont.sk_font(size: 14)]).width
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -img.size.width-5, bottom: 0, right: img.size.width+5)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: width, bottom: 0, right: -width)
    }
}
