//
//  SKGradenInfoItemVControl.swift
//  KindergartenPApplication
//
//  Created by iOS-dev on 2020/8/28.
//  Copyright © 2020 iMFun.com. All rights reserved.
//

import UIKit

class SKGradenInfoItemControl: UIControl {
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = SKTheme.disabledColor
        view.cornerRadius = 25.0
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var leftTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "园所名称".localized
        label.font = UIFont.sk_font(size: 16)
        label.textColor = UIColor.sk_hexColor("#333333")
        label.textAlignment = .left
        return label
    }()
    
    lazy var actionBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add"), for: UIControl.State.normal)
        btn.backgroundColor = UIColor.sk_hexColor("#F4F4F4")
        btn.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var rightTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "李老师 李老师 李老师 李老师 李老师 李老师".localized
        label.font = UIFont.sk_font(size: 16)
        label.textColor = UIColor.sk_hexColor("#333333")
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    enum SKGradenInfoItemType {
        case text,action,image
    }
    
    private var type: SKGradenInfoItemType = .text
    
    private var topAlignment: Bool = false
    
    var selectedBlock: ((SKGradenInfoItemType,SKGradenInfoItemControl?) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        addEvents()
    }
    
    init(frame: CGRect,type:SKGradenInfoItemType, title: String, topAlignment: Bool = false) {
        super.init(frame: frame)
        self.type = type
        self.topAlignment = topAlignment
        leftTitleLabel.text = "\(title):"
        setupUI()
        addEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        addSubview(leftTitleLabel)
        
        leftTitleLabel.snp.makeConstraints { (make) in
            if self.topAlignment {
                make.top.equalTo(10)
            } else {
                make.centerY.equalToSuperview()
            }
            
            make.left.equalTo(20)
            make.width.greaterThanOrEqualTo(80)
        }
        
        switch type {
        case .text:
            leftTitleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(10)
                make.left.equalTo(20)
                make.width.greaterThanOrEqualTo(80)
            }
            
            addSubview(rightTitleLabel)
            rightTitleLabel.snp.makeConstraints { (make) in
                make.left.greaterThanOrEqualTo(leftTitleLabel.snp.right).offset(10)
                make.right.equalTo(-20)
                make.height.greaterThanOrEqualTo(20)
                make.top.equalTo(leftTitleLabel)
                make.bottom.equalTo(-10)
            }
        case .action:
            addSubview(actionBtn)
            actionBtn.snp.makeConstraints { (make) in
                make.left.greaterThanOrEqualTo(leftTitleLabel.snp.right).offset(10)
                make.right.equalTo(-20)
                make.top.equalTo(10)
                //                make.centerY.equalTo(leftTitleLabel)
                make.size.equalTo(CGSize(width: 150, height: 150))
                make.bottom.equalTo(-10)
            }
        case .image:
            addSubview(iconView)
            iconView.snp.makeConstraints { (make) in
                make.left.greaterThanOrEqualTo(leftTitleLabel.snp.right).offset(10)
                make.top.equalTo(10)
                make.right.equalTo(-20)
                make.size.equalTo(CGSize(width: 50, height: 50))
                make.bottom.equalTo(-10)
            }
        }
        backgroundColor = .white
    }
    
    func addEvents() {
        
        actionBtn.addClick { [weak self] in
            if let block = self?.selectedBlock, let type = self?.type {
                block(type,self)
            }
        }
    }
    
    func updateContent(rightTitle: String, icon: UIImage? = nil) {
        switch type {
        case .action:
            actionBtn.setTitle(rightTitle, for: .normal)
            guard let img = icon else { return }
            actionBtn.setBackgroundImage(img, for: UIControl.State.normal)
        case .text:
            rightTitleLabel.text = rightTitle
        case .image:
            guard let img = icon else { return }
            iconView.image = img
        }
    }
    
    func updateIcon(img:UIImage) {
        iconView.image = img
    }
    
    func updateActionIconWithSourceUrl(imgUrl:String) {
        guard let url = URL(string: imgUrl) else {
            return
        }
        actionBtn.setImage(nil, for: UIControl.State.normal)
//        actionBtn.sd_setBackgroundImage(with: url, for: UIControl.State.normal, completed: nil)
    }
    
    func updateIconWithUrl(imgUrl:String) {
//        guard let url = URL(string: SKApi.baseUrl+imgUrl) else {
//            return
//        }
//        actionBtn.setImage(nil, for: UIControl.State.normal)
//        iconView.sd_setImage(with: url, placeholderImage: SKTheme.defaultAvatar, options: SDWebImageOptions.retryFailed, completed: nil)
    }
}
