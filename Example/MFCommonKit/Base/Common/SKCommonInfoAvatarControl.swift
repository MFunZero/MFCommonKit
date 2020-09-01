//
//  SKCommonInfoAvatarControl.swift
//  KindergartenPApplication
//
//  Created by iOS-dev on 2020/8/28.
//  Copyright © 2020 iMFun.com. All rights reserved.
//

import UIKit

class SKCommonInfoAvatarControl: UIControl {
    lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = SKTheme.disabledColor
        view.cornerRadius = 25.0
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sk_font(size: 16)
        label.textColor = UIColor.sk_hexColor("#333333")
        label.text = "幼儿照片:".localized
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sk_font(size: 14)
        label.textColor = UIColor.sk_hexColor("#999999")
        label.text = "张晓红".localized
        label.textAlignment = .right
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
        addSubview(avatarView)
        addSubview(sepView)
        backgroundColor = .white
    }
    
    func showBottomLine(show: Bool) {
        
        sepView.isHidden = !show
        
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20) 
            make.centerY.equalToSuperview().priority(999)
            make.height.equalTo(20)
        }
        
        avatarView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
        make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 50,height: 50))
        }
        
        sepView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalTo(20)
            make.centerX.equalToSuperview()
        }
    }
    
    func update(value:[String:String]) {
        titleLabel.text = value.keys.first ?? "" 
    }
    
    func updateIconWithUrl(imgUrl:String) {
//        guard let url = URL(string: SKApi.baseUrl+imgUrl) else {
//            return
//        }
//         
//        avatarView.sd_setImage(with: url, placeholderImage: SKTheme.defaultAvatar, options: SDWebImageOptions.retryFailed, completed: nil)
    }
}

