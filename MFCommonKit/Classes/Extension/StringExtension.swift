//
//  StringExtension.swift
//  XJXN
//
//  Created by simple on 2018/11/26.
//  Copyright © 2018年 simple. All rights reserved.
//

import Foundation

public extension String {    
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
 
public extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    
    func localized(tableName: String) -> String{
        return NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
    }
}
