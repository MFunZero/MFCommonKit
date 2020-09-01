//
//  UIViewExtension.swift
//  liangzhan
//
//  Created by simple on 2018/11/25.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit

public extension UIView {
    @IBInspectable var cornerRadius:CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(newCornerRadius) {
            self.layer.cornerRadius = newCornerRadius
        }
    }    
    @IBInspectable var borderWidth:CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(newBorderWidth) {
            self.layer.borderWidth = newBorderWidth
        }
    }    
    @IBInspectable var borderColor:UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
        set(newBorderColor) {
            self.layer.borderColor = newBorderColor?.cgColor
        }
    }    
    @IBInspectable var customCornerRadius:CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(newCornerRadius) {
            self.layer.cornerRadius = newCornerRadius
        }
    }
    // MARK: - 常用位置属性
    var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }    
    var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }    
    var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }    
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }    
    var right:CGFloat {
        get {
            return self.left + self.width
        }
    }    
    var bottom:CGFloat {
        get {
            return self.top + self.height
        }
    }    
    var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }    
    var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }    
    static func instanceFromNib() -> UIView?{
        let clsName = NSStringFromClass(self)
        let names = clsName.split(separator: ".")
        let nibs = UINib(nibName:String(names.last ?? ""), bundle: nil).instantiate(withOwner: nil, options: nil)
        if let item = nibs.first {
            return item as? UIView
        }
        return nil
    }
    
    func showReadBadge(count: Int){
        guard count > 0 else {
            self.hideBadge()
            return
        }
        self.hideBadge()
        self.clipsToBounds = false
        let badgeView = UIView(frame: CGRect(x: self.bounds.origin.x+self.bounds.width-5, y: 0, width: 10, height: 10))
        badgeView.cornerRadius = 5
        badgeView.tag = 999
        badgeView.clipsToBounds = true
        badgeView.backgroundColor = UIColor.red
        if count > 0 {
            badgeView.cornerRadius = 8
            badgeView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
            let countLabel = UILabel()
            countLabel.font = UIFont.sk_font(size: 8)
            countLabel.textColor = .white
            countLabel.text = count < 999 ? "\(count)":"..."
            countLabel.sizeToFit()
            badgeView.addSubview(countLabel)
            countLabel.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }
        
        if self.subviews.count == 1, let subview = self.subviews.first, subview.isKind(of: NSClassFromString("UIButtonLabel") ?? UIButton.classForCoder()) {
            self.addSubview(badgeView)
            badgeView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(subview).offset(-3)
                make.left.equalTo(subview.snp.right)
                make.size.equalTo(CGSize(width: 16, height: 16))
            }
        } else {
            self.addSubview(badgeView)
            badgeView.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(self.snp.right).offset(-10)
                make.size.equalTo(CGSize(width: 16, height: 16))
            }
        }
        
        self.bringSubviewToFront(badgeView)
    }
    
    func showDotBadge(){
        hideBadge()
        self.clipsToBounds = false
        let badgeView = UIView(frame: CGRect(x: self.bounds.origin.x+self.bounds.width-5, y: 0, width: 10, height: 10))
        badgeView.cornerRadius = 5
        badgeView.tag = 999
        badgeView.clipsToBounds = true
        badgeView.backgroundColor = UIColor.red
        
        if self.subviews.count == 1, let subview = self.subviews.first, subview.isKind(of: NSClassFromString("UIButtonLabel") ?? UIButton.classForCoder()), let btn = self as? UIButton,let titleLabel = btn.titleLabel, let text = btn.currentTitle {
            self.addSubview(badgeView)
            
            let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font : titleLabel.font ?? UIFont.sk_font(size: 14)]).width
            
            badgeView.snp.makeConstraints { (make) in
                make.centerY.equalTo(subview).offset(-5)
                make.centerX.equalTo(subview).offset(width/2)
                make.size.equalTo(CGSize(width: 10, height: 10))
            }
            badgeView.layoutIfNeeded()
        } else {
            self.addSubview(badgeView)
            badgeView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalTo(self.snp.right).offset(-5)
                make.size.equalTo(CGSize(width: 10, height: 10))
            }
        }
        
        self.bringSubviewToFront(badgeView)
    }
    
    func hideBadge(){
        self.viewWithTag(999)?.removeFromSuperview()
    }
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}

public struct UIRectSide : OptionSet {
    
    public let rawValue: Int
    
    public static let left = UIRectSide(rawValue: 1 << 0)
    
    public static let top = UIRectSide(rawValue: 1 << 1)
    
    public static let right = UIRectSide(rawValue: 1 << 2)
    
    public static let bottom = UIRectSide(rawValue: 1 << 3)
    
    public static let all: UIRectSide = [.top, .right, .left, .bottom]
    
    
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue;
        
    }
    
}

public extension UIView{
    
    ///画虚线边框
    func drawDashLine(strokeColor: UIColor = UIColor.sk_hexColor("#E8E8E8"), lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5, corners: UIRectSide) {
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = self.bounds
        
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        shapeLayer.fillColor = UIColor.blue.cgColor
        
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        //每一段虚线长度 和 每两段虚线之间的间隔
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        
        if corners.contains(.left) {
            
            path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
            
            path.addLine(to: CGPoint(x: 0, y: 0))
            
        }
        
        if corners.contains(.top){
            
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            
        }
        
        if corners.contains(.right){
            
            path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            
        }
        
        if corners.contains(.bottom){
            
            path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            
            path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
            
        }
        
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    ///画实线边框 有设置过bounds的view使用
    func drawLine(strokeColor: UIColor = UIColor.sk_hexColor("#E8E8E8"), lineWidth: CGFloat = 1, corners: UIRectSide) {
        
        if corners == UIRectSide.all {
            
            self.layer.borderWidth = lineWidth
            
            self.layer.borderColor = strokeColor.cgColor
            
        }else{
            
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.bounds = self.bounds
            
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            
            shapeLayer.fillColor = UIColor.blue.cgColor
            
            shapeLayer.strokeColor = strokeColor.cgColor
            
            shapeLayer.lineWidth = lineWidth
            
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            
            let path = CGMutablePath()
            
            if corners.contains(.left) {
                
                path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
                
                path.addLine(to: CGPoint(x: 0, y: 0))
                
            }
            
            if corners.contains(.top){
                
                path.move(to: CGPoint(x: 0, y: 0))
                
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
                
            }
            
            if corners.contains(.right){
                
                path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
                
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                
            }
            
            if corners.contains(.bottom){
                
                path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
                
            }
            
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
            
        }
    } 
    
}

public extension UIView {
    
    func rootView() -> UIView {
        var view = self
        while view.superview != nil {
            view = view.superview!
        }
        return view
    }
    
    var isOnWindow: Bool {
        return self.rootView() is UIWindow
    }
}
