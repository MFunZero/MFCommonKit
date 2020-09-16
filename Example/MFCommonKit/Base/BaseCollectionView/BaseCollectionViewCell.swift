//
//  BaseCollectionViewCell.swift
//  SKEmployee
//
//  Created by iOS开发 on 2019/8/13.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    var isEditing: Bool = false {
        didSet {
             updateCheckStateUI()
        }
    }
    // 自定义选中状态
    var isSelectedCustom: Bool = false {
        didSet {
             updateSelectedStateUI()
        }
    }
    
    var cellDeleteBlock: ((BaseCollectionViewCell, IndexPath)->())?
    
    var model: Any? {
        didSet{
            updateModel()
        }
    }
    
    weak var controller: UIViewController?
    
    override var reuseIdentifier: String? { return "cell" }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupContraints()
        addEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateModel() {
        
    }
    
    func setupUI() {
        
    }
    
    func setupContraints() {
        
    }
    
    func addEvents() {
        
    }
    
    func updateCheckStateUI() {
        
    }
    
    func updateSelectedStateUI() {
        
    }
    
}
