//
//  SKCommonCollectionView.swift
//  KindergartenTApplication
//
//  Created by iOS-dev on 2020/3/18.
//  Copyright © 2020 iMFun.com. All rights reserved.
//

import UIKit


class SKCommonCollectionView: UICollectionView {
    
    @IBInspectable var row: Int = 4
    @IBInspectable var sep: CGFloat = 10
    @IBInspectable var maxCol: Int = 4
    // cell宽高比
    @IBInspectable var scaleWH: CGFloat = 0.8
    // 公共头部banner区域
    @IBInspectable var commonHeaderH: CGFloat = 200
    
    // 是否根据数据源自动更新高度
    @IBInspectable var shouldLayoutH: Bool = false
    @IBOutlet weak var membersH: NSLayoutConstraint!
    // 是否重新计算layout
    @IBInspectable var layoutCustom: Bool = true

    // 是否编辑状态
    var isEditing: Bool = false {
        didSet {
            allowsMultipleSelection = isEditing
            self.reloadData()
        }
    }
    
    var selectedBlock: ((Any, IndexPath)->())?
    var deselectedBlock: ((Any, IndexPath)->())?
    var cellBlock: ((BaseCollectionViewCell, IndexPath)->())?
    var headerViewUIBlock: ((UIView, IndexPath)->())?
    
    var dataArray:[Any] = []
    // 根据dataArray的下标取值，
    var multiSelectedIndex:[IndexPath] = []
    
    private var elementKinds:((String?,String?)) = (nil,nil)
    // 是否显示公共HeaderView
    private var showCommonHeader:Bool = false
    // 是否多section
    var multiSections:Bool = false
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    func registerHeaderFooterView<T>(cls: T.Type,isNib: Bool = false,viewKind kind: String) where T: UICollectionReusableView {
        guard let clsName = NSStringFromClass(cls).split(separator: ".").last else {
            return
        }
        if isNib {
            self.register(UINib(nibName: String(clsName), bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: kind)
        } else {
            self.register(cls, forSupplementaryViewOfKind: kind, withReuseIdentifier: kind)
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            self.elementKinds.0 = kind
        } else {
            self.elementKinds.1 = kind
        }
    }
    
    func registerCommonHeaderView<T>(cls: T.Type,isNib: Bool = false) where T: UICollectionReusableView {
        guard let clsName = NSStringFromClass(cls).split(separator: ".").last else {
            return
        }
        if isNib {
            self.register(UINib(nibName: String(clsName), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "commonHeader")
        } else {
            self.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "commonHeader")
        }
        
        showCommonHeader = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout, layoutCustom else { return  }
        let sectionInset = layout.sectionInset
        let width = (self.width-CGFloat(maxCol-1) * sep - sectionInset.left - sectionInset.right) / CGFloat(maxCol)
        //        layout.estimatedItemSize = CGSize(width: width, height: width/scaleWH)
        layout.itemSize = CGSize(width: width, height: width/scaleWH)
        layout.minimumLineSpacing = sep
        //        layout.headerReferenceSize = UICollectionViewFlowLayout.automaticSize
        //        layout.footerReferenceSize = UICollectionViewFlowLayout.automaticSize
        guard shouldLayoutH else { return }
        guard let hConstraints = self.membersH else {
            self.height = self.contentSize.height
            return
        }
        hConstraints.constant = self.contentSize.height
    }
    
}

extension SKCommonCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if multiSections {
            if showCommonHeader {
                return dataArray.count + 1
            }
            return dataArray.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if multiSections {
            if showCommonHeader {
                if  section == 0 {
                    return 0
                }
                // MARK: TODO
                return 1
//                else if let sectionArray = dataArray[section-1] as? SKLibraryListModel {
//                    return sectionArray.list.count
//                } else {
//                    if let sectionArray = dataArray[section-1] as? [Any] {
//                        return sectionArray.count
//                    }
//                }
            } else if let sectionArray = dataArray[section] as? [Any] {
                return sectionArray.count
            }
            return 0
        } else {
            return dataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BaseCollectionViewCell else {
            return BaseCollectionViewCell()
        }
        cell.isEditing = isEditing
        if multiSelectedIndex.contains(indexPath) {
            cell.isSelectedCustom = true
        } else {
            cell.isSelectedCustom = false
        }
        if multiSections {
            if showCommonHeader {
                // MARK: TODO
//                if indexPath.section != 0, let sectionArray = dataArray[indexPath.section-1] as? SKLibraryListModel {
//                    cell.model = sectionArray.list[indexPath.row]
//                }
            } else if let sectionArray = dataArray[indexPath.section] as? [Any] {
                cell.model = sectionArray[indexPath.row]
            }
        } else {
            cell.model = dataArray[indexPath.row]
        }
        if let block = self.cellBlock {
            block(cell, indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 && showCommonHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "commonHeader", for: indexPath)
            return header
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kind, for: indexPath)
        if let block = headerViewUIBlock {
            block(header, indexPath)
        }
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if showCommonHeader, section == 0 {
            return CGSize(width: self.width, height: commonHeaderH)
        }
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        return layout.headerReferenceSize
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        if elementKinds.1 != nil {
    //
    //            return UICollectionViewFlowLayout.automaticSize
    //        }
    //        return CGSize.zero
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell, let model = cell.model else {
            return
        }
        if !multiSelectedIndex.contains(indexPath) {
            multiSelectedIndex.append(indexPath)
        }
        if isEditing {
            cell.isSelectedCustom = true
        }
        if let block = self.selectedBlock {
            block(model, indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell, let model = cell.model else {
            return
        }
        
        if isEditing {
            cell.isSelectedCustom = false
        }
        if let k = multiSelectedIndex.firstIndex(of: indexPath) {
            multiSelectedIndex.remove(at: k)
        }
        if let block = self.deselectedBlock {
            block(model, indexPath)
        }
    }
    
}
