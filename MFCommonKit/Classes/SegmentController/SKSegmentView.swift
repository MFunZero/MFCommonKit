//
//  SKSegmentView.swift
//  SKEmployee
//
//  Created by MFun on 2019/8/1.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit

@objc public protocol SKSegmentViewDelegate: class {
    
    func didSelected(index: Int)
    
}

open class SKSegmentView: UIView {
 
    private var animatedView: UIView = UIView(frame: CGRect.zero)
    private var titleButtonArray: [UIButton] = []
    weak var delegate: SKSegmentViewDelegate?
    open var selectedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI(frame: CGRect){
        self.backgroundColor = UIColor.white
    }

    open func configTitles(titles: [String],normalTitleColor: UIColor?, selectedTitleColor: UIColor?,edges: UIEdgeInsets) {
        assert(titles.count > 0 ,"titles's count must bigger than zero")
        var x = edges.left
        let width = (self.width-edges.left-edges.right)/CGFloat(titles.count)
        let height = self.height - edges.top - edges.bottom
        var i = 0
        for title in titles {
            x = edges.left + width * CGFloat(i)
            let rect = CGRect(x: x, y: edges.top, width: width, height: height)
            let btn = UIButton(frame: rect, normalTitle: title, font: UIFont.sk_font(size: 14), normalTitleColor: normalTitleColor, selectedTitleColor: selectedTitleColor,  target: self, action: #selector(btnClicked(sender:)))
            btn.tag = i
            addSubview(btn)
            titleButtonArray.append(btn)
            i += 1
        }
        
        ///动画滚动条
        addSubview(animatedView)
        animatedView.width = width 
        animatedView.height = 2
        animatedView.cornerRadius = 1
        animatedView.clipsToBounds = true
        animatedView.center = CGPoint(x: edges.left+width/2, y: self.height-1)
        titleButtonArray.first?.isSelected = true
        animatedView.backgroundColor = selectedTitleColor ?? UIColor.sk_hexColor("#3685ED")
    }
    
    open func configTitlesWithIcon(titles: [String],icons: [String],iconSelectedSufix: String,normalTitleColor: UIColor?, selectedTitleColor: UIColor?,edges: UIEdgeInsets) {
        assert(titles.count > 0 ,"titles's count must bigger than zero")
        var x = edges.left
        let width = (self.width-edges.left-edges.right)/CGFloat(titles.count)
        let height = self.height - edges.top - edges.bottom
        var i = 0
        for title in titles {
            x = edges.left + width * CGFloat(i)
            let rect = CGRect(x: x, y: edges.top, width: width, height: height)
            let btn = UIButton(frame: rect, normalTitle: title, font: UIFont.sk_font(size: 14), normalTitleColor: normalTitleColor, selectedTitleColor: selectedTitleColor,  target: self, action: #selector(btnClicked(sender:)))
            btn.setImage(UIImage(named: "\(icons[i])"), for: UIControl.State.normal)
            btn.setImage(UIImage(named: "\(icons[i])\(iconSelectedSufix)"), for: UIControl.State.selected)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            btn.tag = i
            addSubview(btn)
            titleButtonArray.append(btn)
            i += 1
        }
        
        ///动画滚动条
        addSubview(animatedView)
        animatedView.width = width
        animatedView.height = 2
        animatedView.cornerRadius = 1
        animatedView.clipsToBounds = true
        animatedView.center = CGPoint(x: edges.left+width/2, y: self.height-1)
        titleButtonArray.first?.isSelected = true
        animatedView.backgroundColor = selectedTitleColor ?? UIColor.sk_hexColor("#3685ED")
    }
    
    open func reloadTitles(titles: [String]) {
        var i = 0
        for title in titles {
//            titleButtonArray[i].titleLabel?.text = title
            titleButtonArray[i].setTitle(title, for: UIControl.State.selected)
            titleButtonArray[i].setTitle(title, for: UIControl.State.normal)

            i += 1
        }
    }
    
    open func showBadge(badge: Int, withBtnIndex: Int) {
        self.titleButtonArray[withBtnIndex].showReadBadge(count: badge)
    }
    
    open func showDotBadge(withBtnIndex: Int) {
        self.titleButtonArray[withBtnIndex].showDotBadge()
    }
    
    open func hidBadge(withBtnIndex: Int) {
        self.titleButtonArray[withBtnIndex].hideBadge()
    }
    
    open func setSelectedIndex(index: Int) {
        guard titleButtonArray.count > index, !titleButtonArray[index].isSelected else {
            SKLog("已是选中项")
            return
        }
        selectedIndex = index
        titleButtonArray[index].isSelected = true
        resetOthers(exinclude: index)
//        btnClicked(sender: titleButtonArray[index])
        /// callBack
//        if let delegate = self.delegate {
//            delegate.didSelected(index: index)
//        }
    }
    
}

public extension SKSegmentView {
    
    @objc private func btnClicked(sender: UIButton){
        ///
        guard !sender.isSelected else {
            SKLog("已是选中项")
            return
        }
        let index = sender.tag
        selectedIndex = index
        sender.isSelected = true
        resetOthers(exinclude: index)
        /// callBack
        if let delegate = self.delegate {
            delegate.didSelected(index: index)
        }
        
    }
    
    private func resetOthers(exinclude: Int) {
        for btn in titleButtonArray {
            if btn.tag != exinclude {
                btn.isSelected = false
            }
        }
        
        let centerX = titleButtonArray[exinclude].left + titleButtonArray[exinclude].width/2
            UIView.animate(withDuration: 0.25, animations: {
            self.animatedView.center = CGPoint(x: centerX, y: self.animatedView.centerY)
        }) { (finished) in
            if finished {
                
            }
        }
        
    }
    
}
