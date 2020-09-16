//
//  SKClassesSelectedAlertView.swift
//  ChildCareManagement
//
//  Created by iOS-dev on 2020/8/5.
//  Copyright © 2020 isuike.com. All rights reserved.
//

import UIKit

class SKClassesSelectedAlertView: UIView {
    
    lazy var bgControll: UIControl = {
        let icon = UIControl()
        icon.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        return icon
    }()
    
    lazy var collectionView: BaseCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        collectionView.width = 320
        collectionView.itemH = 37.0
        collectionView.sep = 10
        collectionView.maxCol = 4
        collectionView.shouldLayoutH = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isCustom = true
        return collectionView
    }()
    
    private var contentView: UIView = {
        let icon = UIView()
        icon.cornerRadius = 20.0
        icon.clipsToBounds = true
        return icon
    }()
    
    // confirm回调
    private var callback: ((Any,Int) -> ())?
    // 数据源
    private var dataArray: [Any] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        addEvents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(collectionView)
        addSubview(bgControll)
        
        collectionView.registerCell(cls: BaseCollectionViewCell.self)
        
    }
    
    func setupConstraints() {
        
        contentView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(120)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgControll.snp.makeConstraints { (make) in
            make.bottom.right.left.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom)
        }
        
    }
    
    func addEvents() {
        bgControll.addClick { [weak self] in
            self?.removeFromSuperview()
        }
        
        collectionView.selectedBlock = { [weak self] model, index in
            if let block = self?.callback {
                block(model, index.row)
            }
            self?.removeFromSuperview()
        }
        
    }
    
    func show(vc: UIViewController?,relateView: UIView?, dataArray:[Any], callBack:@escaping((Any,Int) -> ())) {
        self.callback = callBack
        showAlertView(vc: vc,relateView: relateView)
        collectionView.dataArray = dataArray
        collectionView.reloadData()
    }
    
    private func showAlertView(vc: UIViewController?,relateView: UIView?) {
        guard let window = vc?.view, let relate = relateView else {
            return
        }
        let rect = relate.convert(relate.bounds, to: window)
        let newRect = window.convert(rect, to: window)
        window.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(newRect.height+newRect.origin.y+4.0)
        }
    }
    
    // 如果现实则移除
    static func isOnWindow(remove: Bool,vc: UIViewController?) -> Bool{
        guard let window = vc?.view else {
            return false
        }
        let subViews = window.subviews
        for item in subViews {
            if item.isKind(of: SKClassesSelectedAlertView.self) {
                if remove {
                    item.removeFromSuperview()
                }
                return true
            }
        }
        return false
    }
    
}
