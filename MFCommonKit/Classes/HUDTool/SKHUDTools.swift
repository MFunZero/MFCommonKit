//
//  SKHUDTools.swift
//  SKEdu
//
//  Created by iOS开发 on 2019/5/31.
//  Copyright © 2019 shanxidongda. All rights reserved.
//

import Foundation
import MBProgressHUD
import MFCommonKit


public class SKHUDTools {    
    /// 菊花加载
    class func showLoading() {
        hiddenHUD()
        guard let hud = addView() else { return }
        
        hud.backgroundView.style = .solidColor
        hud.contentColor = .white
        hud.bezelView.backgroundColor = UIColor.sk_hexColor("#333333")
        hud.bezelView.style = .solidColor
        hud.isUserInteractionEnabled = false
        hud.removeFromSuperViewOnHide = true
        
    }    
    /// 显示文字并自动消失
    class func showTextAutomaticDismiss(title: String?, color: UIColor = UIColor.sk_hexColor("#cccccc")) {
        hiddenHUD()
        guard let hud = addView() else { return }
        let hudView = SKHudView()
        
        hudView.showText(title: title ?? "", color: color)
        
        hud.customView = hudView
        hud.mode = .customView
        hud.backgroundView.style = .solidColor
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = nil
        hud.contentColor = nil
        
        hud.isUserInteractionEnabled = false
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 2.0)
    }    
    /// 显示文字并在相应时间后自动消失
    class func showTextAutomaticDismiss(title: String?, time: TimeInterval) {
        hiddenHUD()
        guard let hud = addView() else { return }
        
        hud.label.text = title
        hud.label.numberOfLines = 0
        hud.mode = .text
        hud.backgroundView.style = .solidColor
        hud.contentColor = .white
        hud.bezelView.backgroundColor = .black
        hud.bezelView.style = .blur
        hud.isUserInteractionEnabled = false
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: time)
        
    }
}

extension SKHUDTools {
    /// 隐藏默认的WindowHUD
    class func hiddenHUD() {
        guard let appdelegate = UIApplication.shared.delegate else {
            return
        }
        guard let view = appdelegate.window ?? nil else {
            return
        }
        MBProgressHUD.hide(for: view, animated: true)
    }
    /// 添加默认HUDWindowView
    class func addView() -> MBProgressHUD? {
        guard let appdelegate = UIApplication.shared.delegate else {
            return nil
        }
        guard let view = appdelegate.window ?? nil else {
            return  nil
        }
        
        return MBProgressHUD.showAdded(to: view, animated: true)
    }    
    class func showRecordProgressView(text:String) -> UILabel? {
        hiddenHUD()
        guard let appdelegate = UIApplication.shared.delegate else {
            return nil
        }
        guard let view = appdelegate.window ?? nil else {
            return nil
        }
        let bgview = UIView()
        let subView = UIImageView()
        subView.image = UIImage(named: Bundle.loadBundleAssets(withName: "Chat_record_circle"))
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.sk_font(size: 12)
        bgview.addSubview(label)
        bgview.addSubview(subView)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        subView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.top.equalToSuperview()
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        
        hud.customView = bgview
        hud.minSize = CGSize(width: 70, height: 70)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 4.0
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.isRemovedOnCompletion = false
        subView.layer.add(rotationAnimation, forKey: nil)
        
        return label
    }
    
}
