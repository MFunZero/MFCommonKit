//
//  UILabelExtension.swift
//  XJXN
//
//  Created by simple on 2018/11/27.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 添加便利构造函数
    convenience init(frame: CGRect = CGRect.init(),title: String? = nil,font: UIFont,titleColor: UIColor = .black,backColor: UIColor? = .clear,alignment: NSTextAlignment = .left) {
        self.init()
        self.text = title
        self.frame = frame
        self.font = font
        self.textColor = titleColor
        self.backgroundColor = backColor
        self.textAlignment  = alignment
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        let fontSize = self.font.pointSize
        self.font = UIFont.sk_font(size: UInt32(fontSize), name: PingFangSCRegular)
    }
    
    @available(iOS 13.0, *)
    func underline(color: UIColor = .link) {
        
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString) 
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
            
        }
    }
    
}
