//
//  SKVFPreViewViewController.swift
//  KindergartenTApplication
//  Video  Image 预览视图
//  Created by iOS-dev on 2020/9/9.
//  Copyright © 2020 isuike.com. All rights reserved.
//

import UIKit
import MFCommonKit

class SKVFPreViewViewController: BaseViewController {
    
    open lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.sk_hexColor("#F6F5F8")
        return collectionView
    }()
    // 当前页面index
    private var selectedIndex: Int = 0
    // 媒体资源文件数组
    var mediaArray: [Any] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        
    }
    
    private func makePage(index: IndexPath) -> BaseViewController? {
        guard mediaArray.count > index.row else { return nil }
        return nil
    }
    
}

extension SKVFPreViewViewController: SKSegmentViewDelegate {
    
    open func didSelected(index: Int) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
}

extension SKVFPreViewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //        cell.backgroundColor = UIColor.ramdomColor
        self.children[indexPath.row].view.frame = cell.bounds
        cell.addSubview(self.children[indexPath.row].view)
        return cell
    }
    
}

extension SKVFPreViewViewController: UIScrollViewDelegate {
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset:
        UnsafeMutablePointer<CGPoint>) {
        if scrollView == collectionView {
            let x = targetContentOffset.pointee.x
            let pageWidth = scrollView.width
            var page = selectedIndex
            let moveIndex = x - pageWidth * CGFloat(page)
            
            if moveIndex < -pageWidth * 0.5 {
                page -= 1
                selectedIndex = page
            }else if moveIndex > pageWidth * 0.5 {
                page += 1
                selectedIndex = page
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            //            let x = scrollView.contentOffset.x
            //            let pageWidth = scrollView.width
            //            var page = segmentView.selectedIndex
            //            let moveIndex = x - pageWidth * CGFloat(page)
            //
            //            if moveIndex < -pageWidth * 0.5 {
            //                page -= 1
            //                segmentView.setSelectedIndex(index: page)
            //            }else if moveIndex > pageWidth * 0.5 {
            //                page += 1
            //                segmentView.setSelectedIndex(index: page)
            //            }
        }
    }
    
}
