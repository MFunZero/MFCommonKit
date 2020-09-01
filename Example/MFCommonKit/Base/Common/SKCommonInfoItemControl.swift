//
//  SKCommonInfoItemControl.swift
//  KindergartenPApplication
//
//  Created by iOS-dev on 2020/3/18.
//  Copyright © 2020 iMFun.com. All rights reserved.
//

import UIKit


/// 使用自动约束时需要设置此视图的高度
class SKCommonInfoItemControl: UIControl {
     
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sk_font(size: 16)
        label.textColor = UIColor.sk_hexColor("#333333")
        label.text = "张晓红".localized
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sk_font(size: 14)
        label.textColor = UIColor.sk_hexColor("#999999")
        label.text = "张晓红".localized
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "arrow_right")
        return icon
    }()
    
    lazy var sepView: UIView = {
        let icon = UIView()
        icon.backgroundColor = SKTheme.seperatorColor
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI() {
        addSubview(titleLabel)
        addSubview(iconView)
        addSubview(detailLabel)
        addSubview(sepView)
        backgroundColor = .white
    }
    
    func showBottomLine(show: Bool) {
        
        sepView.isHidden = !show
        
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(15)
            make.height.equalTo(20)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(-20)
            //            make.size.equalTo(CGSize(width: 22, height: 28))
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel)
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(20)
            make.right.equalTo(iconView.snp.left).offset(-10)
            make.bottom.lessThanOrEqualTo(-15)
        }
        
        sepView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalTo(20)
            make.centerX.equalToSuperview()
        }
    }
    
    func hideRightIcon(flag: Bool){
        iconView.isHidden = flag
        if flag {
            detailLabel.snp.remakeConstraints { (make) in
                           make.top.equalTo(titleLabel)
                make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
                make.right.equalTo(-20)
                make.bottom.lessThanOrEqualTo(-15)
            }
        } else {
            detailLabel.snp.makeConstraints { (make) in
                            make.top.equalTo(titleLabel)
                make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
                make.right.equalTo(iconView.snp.left).offset(-10)
                make.bottom.lessThanOrEqualTo(-15)
            }
        }
    }
    
    func update(value:[String:String]) {
        titleLabel.text = value.keys.first ?? ""
        detailLabel.text = value.values.first ?? ""
    }
    
    func updateContent(value:String) {
        detailLabel.text = value
        self.layoutIfNeeded()
    }
    
}
