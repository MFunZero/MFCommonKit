//
//  BaseTableViewCell.swift
//  Base
//
//  Created by MFun on 2019/8/7.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit


//MARK:- identifier
extension UITableViewCell {
    static func cell() -> String {
        return String(NSStringFromClass(self).split(separator: ".").last ?? "")
    }
}

class BaseTableViewCellModel {
    // 是否显示checkmark选择图标
    var enableCheckMark: Bool = true
    var selected: Bool = false
    var ext: Any?
    
    init(selected: Bool = false, ext: Any, enableCheckMark: Bool = false) {
        self.selected = selected
        self.ext = ext
        self.enableCheckMark = enableCheckMark
    }
   
}

class BaseTableViewCell: UITableViewCell {
    
    weak var adapter: BaseTableAdapter?
    weak var controller: UIViewController?
    var model: AnyObject? {
        didSet{
            updateModel()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func updateModel(){
        
    }
    
    func setupUI(){
        
    }
    
    func setupConstraints() {
        
    }
    
    func addEvents() {
        
    }
    
}
