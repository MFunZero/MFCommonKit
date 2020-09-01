//
//  SKSegmentViewController.swift
//  SKEmployee
//
//  Created by MFun on 2019/8/1.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit

open class SKSegmentViewController: UIViewController {
    
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
    
    open lazy var segmentView: SKSegmentView = {
        let segmentView = SKSegmentView(frame: CGRect(x: 0, y: 0, width: UIScreen.sk_ScreenWidth(), height: 50))
        segmentView.delegate = self
        return segmentView
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        view.addSubview(segmentView)
        view.addSubview(collectionView)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        
    }
    
    override open func viewDidLayoutSubviews() {
        
        collectionView.frame = CGRect(x: 0, y: segmentView.bottom, width: self.view.width, height: self.view.height - segmentView.height )
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.itemSize = CGSize(width: collectionView.width, height: self.view.height - segmentView.height)
    }
    
    open func setSelectedIndex(index: Int) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(2.0))) {
            self.segmentView.setSelectedIndex(index: index)
            self.collectionView.setContentOffset(CGPoint(x: CGFloat(index)*UIScreen.main.bounds.width, y: 0), animated: true)
//            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
        }
    }
    
}

extension SKSegmentViewController: SKSegmentViewDelegate {
    
    open func didSelected(index: Int) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
}

extension SKSegmentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.children.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.ramdomColor
        self.children[indexPath.row].view.frame = cell.bounds
        cell.addSubview(self.children[indexPath.row].view)
        return cell
    }
    
}

extension SKSegmentViewController: UIScrollViewDelegate {
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset:
        UnsafeMutablePointer<CGPoint>) {
        if scrollView == collectionView {
            let x = targetContentOffset.pointee.x
            let pageWidth = scrollView.width
            var page = segmentView.selectedIndex
            let moveIndex = x - pageWidth * CGFloat(page)
            
            if moveIndex < -pageWidth * 0.5 {
                page -= 1
                segmentView.setSelectedIndex(index: page)
            }else if moveIndex > pageWidth * 0.5 {
                page += 1
                segmentView.setSelectedIndex(index: page)
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
