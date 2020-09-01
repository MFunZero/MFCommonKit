//
//  Extension.swift
//  XJXN
//
//  Created by simple on 2018/12/8.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit
@_exported import SnapKit

public extension UIBarButtonItem {
    
    class func createBarImageButton(imageName: String? = nil, title: String? = nil,isAddBadge: Bool = false,isDot: Bool = false,tag: Int? = nil ,target: Any?,action: Selector) -> UIBarButtonItem {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        
        if let img = imageName {
            btn.setImage(UIImage.init(named: img)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        if let titleText = title {
            btn.setTitle(titleText, for: UIControl.State.normal)
            btn.setTitleColor(UIColor.sk_hexColor("#333333"), for: UIControl.State.normal)
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        //        btn.sizeToFit()
        let item = UIBarButtonItem(customView: btn)
        if let tagBtn = tag {
            btn.tag = tagBtn
        }
        
        if isAddBadge == true {
            let label = UILabel.init(title: nil, font: UIFont.sk_font(size: 8), titleColor: .white, backColor: .red, alignment: .center)
            label.tag = 99999
            label.layer.masksToBounds = true
            label.layer.cornerRadius = isDot ? 4:8
            item.customView?.addSubview(label)
            label.snp.makeConstraints { (make) in
                if isDot {
                    make.centerX.equalTo(btn.snp.right).offset(-4)
                    make.centerY.equalTo(4)
                } else {
                    make.centerX.equalTo(btn.snp.right)
                    make.centerY.equalTo(2)
                }
                make.width.height.equalTo(isDot ? 8:16)
            }
            label.isHidden = true
        }
        return item
    }
    
    func showDotBadge(show: Bool){
        guard let subviews = self.customView?.subviews else { return  }
        for view in subviews {
            /// 根据tag屏蔽UIButtonLabel
            if view.isKind(of: UILabel.self), let lable = view as? UILabel, lable.tag == 99999 {
                view.isHidden = !show
                lable.text = ""
            }
        }
        customView?.layoutIfNeeded()
    }
    
    func updateBadgeNum(num: Int){
        
        guard let subviews = self.customView?.subviews else { return  }
        for view in subviews {
            /// 根据tag屏蔽UIButtonLabel
            if view.isKind(of: UILabel.self), let lable = view as? UILabel, lable.tag == 99999 {
                lable.text = String.init(format: "%d", num)
                if num <= 0 {
                    lable.isHidden = true
                } else if num < 10 {
                    lable.isHidden = false
                    lable.font = UIFont.sk_font(size: 12)
                } else if num < 100 {
                    lable.isHidden = false
                    lable.font = UIFont.sk_font(size: 10)
                } else {
                    view.isHidden = false
                    lable.text = "99+"
                    lable.font = UIFont.sk_font(size: 8)
                }
            }
        }
        
        customView?.layoutIfNeeded()
    }
    
}
