//
//  UIButtonExtension.swift
//  XJXN
//
//  Created by simple on 2018/11/27.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit

public extension UIButton {
    
    func adjustTitleRight() {
        guard let titleLabel = self.titleLabel, let img = self.imageView?.image, let text = self.currentTitle else { return }
        //        if text.count > 5 {
        //            let subString = String(text.prefix(5))
        //            self.setTitle("\(subString)...", for: UIControl.State.selected)
        //        } else {
        //            self.setTitle(text, for: UIControl.State.selected)
        //        }
        let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font : titleLabel.font ?? UIFont.sk_font(size: 14)]).width
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -img.size.width-5, bottom: 0, right: img.size.width)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: width, bottom: 0, right: -width)
    } 
    
    convenience init(frame: CGRect? = CGRect.init(), normalTitle: String? = nil,font:UIFont = UIFont.sk_font(size: 16), normalTitleColor:UIColor? = .black ,backColor:UIColor? = .white,selectedTitleColor:UIColor? = .black, selectedTitle: String? = nil ,cornerRadiu: CGFloat? = 0,backImage: UIImage? = nil,target:Any? = nil,action: Selector? = nil) {
        self.init()
        self.frame = frame ?? CGRect.init()
        titleLabel?.font = font
        setTitle(normalTitle, for: .normal)
        setTitle(selectedTitle ?? normalTitle, for: .selected)
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(selectedTitleColor ?? normalTitleColor, for: .selected)
        backgroundColor = backColor
        setBackgroundImage(backImage, for: .normal)
        if let conner = cornerRadiu {
            self.clipsToBounds = true
            self.layer.cornerRadius = conner
        }
        
        if let act = action,
            let tar = target {
            addTarget(tar, action: act, for: .touchUpInside)
        }
    }
    
    convenience init(frame: CGRect? = CGRect.init(), normalTitle: String? = nil,font:UIFont = UIFont.sk_font(size: 16), normalTitleColor:UIColor? = .black ,backColor:UIColor? = .white, selectedTitle: String? = nil ,cornerRadiu: CGFloat? = 0,backImage: UIImage? = nil,target:Any? = nil,action: Selector? = nil) {
        self.init()
        self.frame = frame ?? CGRect.init()
        titleLabel?.font = font
        setTitle(normalTitle, for: .normal)
        setTitleColor(normalTitleColor, for: .normal)
        backgroundColor = backColor
        setBackgroundImage(backImage, for: .normal)
        if let conner = cornerRadiu {
            self.clipsToBounds = true
            self.layer.cornerRadius = conner
        }
        
        if let act = action,
            let tar = target {
            addTarget(tar, action: act, for: .touchUpInside)
        }
    }
    
}

/// XLLayoutButton的布局方式
///
/// - XLTopImageBottomTitle: 上面图片下面标题
/// - XLTopTitleBottomImage: 上面标题下面图片
/// - XLLeftImageRightTitle: 左边图片右边标题
/// - XLLeftTitleRightImage: 左边标题右边图片
enum XLLayoutButtonType {
    case XLTopImageBottomTitle
    case XLTopTitleBottomImage
    case XLLeftImageRightTitle
    case XLLeftTitleRightImage
    case XLTableViewHeader
}

class XLLayoutButton: UIButton {    
    var layoutType: XLLayoutButtonType?    
    var midSpace: CGFloat = 8.0{
        didSet{
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.sizeToFit()
        imageView?.sizeToFit()
        layoutButtonImageEdgeInsetsStyle(style: layoutType ?? .XLLeftImageRightTitle, space: midSpace)
        
    }    
    /// 便利构造一个按钮
    ///
    /// - Parameters:
    ///   - type: 按钮的布局方式
    ///   - imageStr: 图片
    ///   - titleStr: 标题
    ///   - selectedImageStr: 选中图片
    ///   - titleColor: 标题颜色 - 默认黑色
    ///   - titleFont: 标题字体 - 默认字体，大小16
    convenience init(frame: CGRect = CGRect.init(),type: XLLayoutButtonType,imageStr: String?,titleStr: String?,selectedImageStr: String? = nil,titleColor: UIColor? = .black,titleFont: UIFont = UIFont.sk_font(size: 16),target:Any? = nil,action: Selector? = nil) {
        self.init()
        self.layoutType = type
        setTitle(titleStr, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = titleFont
        if let imageName = imageStr {
            setImage(UIImage.init(named: imageName), for: .normal)
        }
        if let selectedImageName = selectedImageStr {
            setImage(UIImage.init(named: selectedImageName), for: .selected)
        }
        if let act = action,
            let tar = target {
            addTarget(tar, action: act, for: .touchUpInside)
        }
    }    
    // style:图片位置 space:图片与文字的距离
    func layoutButtonImageEdgeInsetsStyle(style:XLLayoutButtonType,space:CGFloat) {
        
        var imageFrame = (self.imageView?.frame)!
        var titleFrame = (self.titleLabel?.frame)!
        
        let imageWidth:CGFloat = (self.imageView?.frame.size.width)!
        let imageHeight:CGFloat = (self.imageView?.frame.size.height)!
        
        var labelWidth:CGFloat = 0
        var labelHeight:CGFloat = 0
        
        labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
        labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        
        var imageEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero
        
        switch style {
        case .XLTopImageBottomTitle:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-space/2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-space/2.0, right: 0)
        case .XLLeftImageRightTitle:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0)
        case .XLTopTitleBottomImage:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-space/2.0, left: -imageWidth, bottom: 0, right: 0)
        case .XLLeftTitleRightImage:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -labelWidth-space/2.0, bottom: 0, right: labelWidth+space/2.0)
        case .XLTableViewHeader:
            imageFrame.origin.x = self.frame.width - imageFrame.width - 15
            self.imageView?.frame = imageFrame
            
            titleFrame.origin.x = 15
            self.titleLabel?.frame = titleFrame
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
    
}
