//
//  UIImageViewExtension.swift
//  KindergartenPApplication
//
//  Created by ios-2 on 2020/1/6.
//  Copyright © 2020 iMFun.com. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func sk_setImage(urlString: String?,placeImage: UIImage?){
//        guard let urlStr = urlString,
//            let imageURL = URL(string: urlStr)  else {
//                image = placeImage
//                return
//                
//        }
        
//        self.sd_setImage(with: imageURL, placeholderImage: placeImage, options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
        
    }
    
    /// 设置图片，默认不切圆角
//    func sk_setImage(urlString: String?,placeImage: UIImage?,corner: Bool = false,cornerR: CGFloat = 20){
//        guard let urlStr = urlString,
//            let imageURL = URL(string: urlStr)  else {
//                image = placeImage
//                return  }
//        kf.indicatorType = .activity
//        var processor = RoundCornerImageProcessor(cornerRadius: 0)
//        if corner == true  {
//            processor = RoundCornerImageProcessor(cornerRadius: cornerR)
//        }
//        kf.setImage(with: imageURL,
//                    placeholder: placeImage,
//                    options: [
//                        .processor(processor),
//                        .scaleFactor(UIScreen.sk_ScreenScale()*0.1),
//                        .transition(.fade(2)),
//                        .fromMemoryCacheOrRefresh ],
//                    progressBlock: nil)
//        { (img, error, type, url) in
//            if let result = error {
//                SKLog("图片下载失败：\(result.localizedDescription)")
//            }
//        }
//    }
//
//    /// 设置图片，默认不切圆角
//    func sk_setImageOnlyCache(urlString: String?,placeImage: UIImage?,corner: Bool = false,cornerR: CGFloat = 20){
//        guard let urlStr = urlString,
//            let imageURL = URL(string: urlStr)  else {
//                image = placeImage
//                return  }
//        kf.indicatorType = .activity
//        var processor = RoundCornerImageProcessor(cornerRadius: 0)
//        if corner == true  {
//            processor = RoundCornerImageProcessor(cornerRadius: cornerR)
//        }
//        kf.setImage(with: imageURL,
//                    placeholder: placeImage,
//                    options: [
//                        .processor(processor),
//                        .scaleFactor(UIScreen.sk_ScreenScale()),
//                        .transition(.fade(2)),
//                        .onlyFromCache ],
//                    progressBlock: nil)
//        { (img, error, type, url) in
//            if let result = error {
//                SKLog("图片下载失败：\(result.localizedDescription)")
//            }
//        }
//    }
    // 360度旋转图片
//    func rotate360Degree() {
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
//        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0) // 旋转角度
//        rotationAnimation.duration = 2 // 旋转周期
//        rotationAnimation.isCumulative = true // 旋转累加角度
//        rotationAnimation.repeatCount = 100000 // 旋转次数
//        layer.add(rotationAnimation, forKey: "rotationAnimation")
//    }
//    // 停止旋转
//    func stopRotate() {
//        layer.removeAllAnimations()
//    }
    
}
