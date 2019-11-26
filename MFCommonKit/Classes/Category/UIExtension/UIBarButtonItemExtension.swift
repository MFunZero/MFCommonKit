//
//  Extension.swift
//  XJXN
//
//  Created by simple on 2018/12/8.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
 
    public class func createBarImageButton(imageName: String,isAddBadge: Bool = false,tag: Int?=nil ,target:Any?,action:Selector) -> UIBarButtonItem {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
       
        btn.addTarget(target, action: action, for: .touchUpInside)
//        btn.sizeToFit()
        let item = UIBarButtonItem.init(customView: btn)
        if let tagBtn = tag {
            btn.tag = tagBtn
        }
        if isAddBadge == true {
            let label = UILabel.init(title: nil, font: UIFont.sk_font(size: 8), titleColor: .white, backColor: .red, alignment: .center)
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 8
            item.customView?.addSubview(label)
//            label.snp.makeConstraints { (make) in
//                make.centerX.equalTo(btn.snp.right)
//                make.centerY.equalTo(2)
//                make.width.height.equalTo(16)
//            }
            label.isHidden = true
        }
        return item
    }    
    func updateBadgeNum(num: Int64){
        
guard let subviews = self.customView?.subviews else { return  }
        for view in subviews {
            if view.isKind(of: UILabel.self), let lable = view as? UILabel{
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
