//
//  BaseCollectionView.swift
//  SKEmployee
//
//  Created by MFun on 2019/8/13.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit

class BaseCollectionView: UICollectionView {
    
    /// 最大行数
    @IBInspectable var maxRow: Int = Int.max
    @IBInspectable var sep: CGFloat = 10
    @IBInspectable var maxCol: Int = 4
//    @IBInspectable var itemH: CGFloat = 120
    @IBInspectable var scaleWH: CGFloat = 0.75
    @IBInspectable var isCustom: Bool = false
    // 是否根据数据源自动更新高度
    @IBInspectable var shouldLayoutH: Bool = false
    @IBOutlet weak var membersH: NSLayoutConstraint!
    
    // 是否编辑状态
    var isEditing: Bool {
        didSet {
            self.reloadData()
        }
    }
    var selectedBlock: ((Any, IndexPath)->())?
    var deselectedBlock: ((Any, IndexPath)->())?
    var cellBlock: ((BaseCollectionViewCell, IndexPath)->())?
    
    var dataArray:[Any] = []
    // 根据dataArray的下标取值，
    var multiSelectedIndex:[IndexPath] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        isEditing = false
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        isEditing = false
        super.init(coder: aDecoder)
    }
    
    func registerCell<T>(cls: T.Type,isNib: Bool = false) where T: BaseCollectionViewCell {
        guard let clsName = NSStringFromClass(cls).split(separator: ".").last else {
            return
        }
        if isNib {
            self.register(UINib(nibName: String(clsName), bundle: nil), forCellWithReuseIdentifier: "cell")
        } else {
            self.register(cls, forCellWithReuseIdentifier: "cell")
        }
        self.delegate = self
        self.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout, isCustom, dataArray.count > 0 else { return  }
        let sectionInset = layout.sectionInset
        let width = (self.width-CGFloat(maxCol-1) * sep - sectionInset.left - sectionInset.right) / CGFloat(maxCol)
        var height = width/scaleWH
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = sep
        
        let rowTemp = self.dataArray.count / maxCol
        let col = self.dataArray.count % maxCol
        
        guard shouldLayoutH else { return }
        self.layoutIfNeeded()
        height += sep
        guard let hConstraints = self.membersH else {
            if rowTemp < maxRow {
                self.height = CGFloat(height * CGFloat(rowTemp) + (col > 0 ? 1:0) * height) + contentInset.top + contentInset.bottom - sep
            }else {
                self.height = height * CGFloat(maxRow) + contentInset.top + contentInset.bottom - sep
            }
            
            superview?.layoutIfNeeded()
            return
        }
        
        if rowTemp < maxRow {
            hConstraints.constant = CGFloat(height * CGFloat(rowTemp) + (col > 0 ? 1:0) * height) + contentInset.top + contentInset.bottom - sep
        }else {
            hConstraints.constant = height * CGFloat(maxRow) + contentInset.top + contentInset.bottom - sep
        }
    }
    
}

extension BaseCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BaseCollectionViewCell else {
            return BaseCollectionViewCell()
        }
        cell.isEditing = isEditing
        if multiSelectedIndex.contains(indexPath) {
            cell.isSelectedCustom = true
        }
        cell.model = dataArray[indexPath.row]
        if let block = self.cellBlock {
            block(cell, indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell, let model = cell.model else {
            return
        }
        if !multiSelectedIndex.contains(indexPath) {
            multiSelectedIndex.append(indexPath)
        }
        cell.isSelectedCustom = true
//        collectionView.reloadItems(at: [indexPath])
        if let block = self.selectedBlock {
            block(model, indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell, let model = cell.model else {
            return
        }
        cell.isSelectedCustom = false
        if let k = multiSelectedIndex.firstIndex(of: indexPath) {
            multiSelectedIndex.remove(at: k)
        }
//        collectionView.reloadItems(at: [indexPath])
        if let block = self.deselectedBlock {
            block(model, indexPath)
        }
    }
    
}
