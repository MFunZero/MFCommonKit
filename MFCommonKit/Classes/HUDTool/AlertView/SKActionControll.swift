//
//  SKActionControll.swift
//  SKEdu
//
//  Created by iOS开发 on 2019/8/22.
//  Copyright © 2019 shanxidongda. All rights reserved.
//

import UIKit

class SKActionControll: UIControl {

    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var hConstraint: NSLayoutConstraint!
    var actionData: SKActionSheetAction? {
        didSet {
            updateModel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateModel() {
        self.namelabel.text = actionData?.title ?? ""
    }
    
}
