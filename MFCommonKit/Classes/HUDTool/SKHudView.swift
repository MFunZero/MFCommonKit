//
//  SKHudView.swift
//  KindergartenPApplication
//
//  Created by iOS-dev on 2020/4/23.
//  Copyright © 2020 isuike.com. All rights reserved.
//

import UIKit

class SKHudView: UIView {
    
    lazy var titleLabel: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.sk_hexColor("#FA6100")
        lable.font = UIFont.sk_font(size: 12)
        //        lable.text = "Alert.DeleteConfirm.title".localized
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.center.equalToSuperview().priority(999)
            make.right.equalTo(-20).priority(999)
            make.height.greaterThanOrEqualTo(20)
        }
        self.layoutIfNeeded()
        self.height = titleLabel.bottom + 10
        cornerRadius = self.height/2
        clipsToBounds = true
        backgroundColor = UIColor.white
        borderWidth = 1.0
        borderColor = UIColor.sk_hexColor("#FA6100")
    }
    
    func showText(title: String, color: UIColor = UIColor.sk_hexColor("#FA6100")) {
        titleLabel.text = title
        titleLabel.layoutIfNeeded()
        self.height = titleLabel.bottom + 10
        cornerRadius = self.height/2
        
        titleLabel.textColor = color
        borderColor = color
    }
    
}
