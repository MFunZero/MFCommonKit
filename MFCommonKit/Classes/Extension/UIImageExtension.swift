//
//  UIImageExtension.swift
//  liangzhan
//
//  Created by simple on 2018/11/25.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit

public extension UIImage {
   
    static func creataImage(imageSize: CGSize = CGSize(width: 40, height: 40),text:String, fillColor: UIColor = UIColor.sk_hexColor("#E8E8E8")) -> UIImage? { // -> UIImage?
        let width = imageSize.width
        let height = imageSize.height
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, UIScreen.main.scale)
        
        // 获得上下文
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        context.setFillColor(fillColor.cgColor)
        // 填充背景色
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        // 画图片
//        image.draw(at: CGPoint(x: 0, y: 0))
        // 画文字
        let attr = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
        let size =  text.size(withAttributes: attr)

        (text as NSString).draw(in: CGRect(x: width/2-size.width/2, y: height/2-size.height/2, width: width, height: height), withAttributes: attr)
        let endImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return endImage
    }
     
    /// 改变图片大小至指定kb
    class func scaleImageToKb(image: UIImage,toKb: Int64) -> UIImage {
        
        if toKb < 1 {
            return image
        }
        
        let kb = toKb * 1024
        var compression:CGFloat = 0.9
        let maxCompression:CGFloat = 0.1
        
        guard var imageData = image.jpegData(compressionQuality: compression) else {
            return image
        }
        
        while imageData.count > kb && compression > maxCompression {
            compression -= 0.05
            guard let newImage = UIImage.init(data: imageData) else {
                return image
            }
            imageData = newImage.jpegData(compressionQuality: compression) ?? imageData
        }
        
        SKLog("图片大小--->\(imageData.count / 1024)kb")
        guard let newImage = UIImage.init(data: imageData) else {
            return image
        }
        return newImage
    }
    
    func scaleToWidth(width: CGFloat) -> UIImage {
        if width > self.size.width {
            return self
        }
        
        let heith = (width/self.size.width) * self.size.height
        let rect = CGRect(x: 0, y: 0, width: width, height: heith)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    
    /// 根据传递的颜色生成图片
    class func createImageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 根据传递的颜色组生成图片
    class func createImageWithColors(colors:[UIColor], size:CGSize = CGSize(width: 100,height: 100)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradientColors = colors.map { (color) -> AnyObject in
            return color.cgColor as AnyObject
        } as NSArray
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors, locations: nil) else { return nil}
        context!.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 切角
    func clipImageCornerRadius(cornerR: CGFloat,topLeft: Bool,topRight: Bool,bottomLeft: Bool,bottomRight: Bool) -> UIImage?{
        
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.sk_ScreenScale())
        
        var path: UIBezierPath = UIBezierPath.init()
        
        if topLeft {
            path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: .topLeft, cornerRadii: CGSize.init(width: cornerR, height: cornerR))
            path.addClip()
        }
        
        if topRight {
            path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: .topRight, cornerRadii: CGSize.init(width: cornerR, height: cornerR))
            path.addClip()
        }
        
        if bottomLeft {
            path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: .bottomLeft, cornerRadii: CGSize.init(width: cornerR, height: cornerR))
            path.addClip()
        }
        
        if bottomRight {
            path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: .bottomRight, cornerRadii: CGSize.init(width: cornerR, height: cornerR))
            path.addClip()
        }
        
        self.draw(at: CGPoint.zero)
        
        //从上下文当中生成一张图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return newImage
    } 
}

