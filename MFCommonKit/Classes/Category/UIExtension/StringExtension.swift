//
//  StringExtension.swift
//  XJXN
//
//  Created by simple on 2018/11/26.
//  Copyright © 2018年 simple. All rights reserved.
//

import Foundation

extension String {    
    ///是否包含字符串
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    /// 截取任意位置到结束
    ///
    /// - Parameter end:
    /// - Returns: 截取后的字符串
    func stringCutToEnd(star: Int) -> String {
        if !(star < count) { return "截取超出范围" }
        let sRang = index(startIndex, offsetBy: star)..<endIndex
        return String(self[sRang])
 
    }    
    //Range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        guard let from_s = from,
             let to_s = to else { return nil }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from_s),
                       length: utf16.distance(from: from_s, to: to_s))
    }    
    static func locailizableString (key: String) -> String {
        return Bundle.main.localizedString(forKey: key, value: "", table: nil)
    }
    
}

extension String{
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
}
 
