//
//  SKActionSheetAlertView.swift
//  SKEdu
//
//  Created by iOS开发 on 2019/8/19.
//  Copyright © 2019 shanxidongda. All rights reserved.
//

import UIKit
import Foundation

enum SKActionSheetActionType: Int { 
    case cancel = 0,none
}

class SKActionSheetAction: NSObject {
    var title: String?
    var subTitle: String?
    var type: SKActionSheetActionType = SKActionSheetActionType.cancel
    init(title: String, type: SKActionSheetActionType = .none) {
        super.init()
        self.title = title
        self.type = type
    }
}

class SKActionSheetAlertView: UIView {
 
    
    @IBOutlet weak var bgView: UIControl!
    
    @IBOutlet var controllArray: [SKActionControll]!
    
    private var completionBlock:((Any,Int)->())?
    private var actions: [SKActionSheetAction] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.addClick {[weak self] in
            self?.removeSelf()
        }
        
    }
    
    func show(classes: [Any],withCompletion completion:@escaping ((Any,Int)->())) {
        self.completionBlock = completion
        guard let data = classes as? [SKActionSheetAction] else { return }
        actions = data
        
        if actions.count >= controllArray.count {
            var i = 0
            for controll in controllArray {
                controll.actionData = actions[i]
                controll.namelabel.text = actions[i].title
                i += 1
            }
        }else {
            var i = 0
            for controll in controllArray {
                if i >= actions.count {
                    controll.hConstraint.constant = 0
//                    controll.layoutIfNeeded()
                    controll.isHidden = true
                    continue
                }
                
                controll.actionData = actions[i]
                controll.namelabel.text = actions[i].title
                i += 1
            }
        } 
        show()
    }
    
    private func show() {
        guard let appDelegate = UIApplication.shared.delegate , let window = appDelegate.window ?? nil else {
            return
        }
        window.addSubview(self)
        window.bringSubviewToFront(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bgView.alpha = 0.0
        
//        hConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0.15
//            self.hConstraint.constant = 280
            //            self.cornerView.layoutIfNeeded()
        }
        
    }
    
    @IBAction func touchAction(_ sender: UIControl) {
        let tag = sender.tag
        if tag ==  0 {
            removeSelf()
        }else if tag <= actions.count {
            if let block = self.completionBlock {
                block(actions[tag-1],tag-1)
            }
        }
        
    }
    
    private func removeSelf() {
        guard let appDelegate = UIApplication.shared.delegate , let window = appDelegate.window, let subViews = window?.subviews  else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.1
//            self.hConstraint.constant = 0
            //            self.cornerView.layoutIfNeeded()
        }) { (flag) in
            if flag {
                for item in subViews {
                    if item.isKind(of: self.classForCoder) {
                        item.removeFromSuperview()
                    }
                }
            }
        }
        
    }
    
    static func remove() {
        guard let appDelegate = UIApplication.shared.delegate , let window = appDelegate.window , let subViews = window?.subviews else {
            return
        }
        
        for item in subViews {
            if item.isKind(of: SKActionSheetAlertView.classForCoder()) {
                item.removeFromSuperview()
            }
        }
    }

}
