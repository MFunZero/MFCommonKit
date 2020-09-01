//
//  BundleExtension.swift
//  liangzhan
//
//  Created by simple on 2018/11/24.
//  Copyright © 2018年 simple. All rights reserved.
//

import Foundation

public extension Bundle {
    
    ///  取得命名空间
    var spaceName : String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }    
    /// 获取当前版本号
    var appVersion : String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }    
    /// 获取build号
    var appBuild :String {
         return object(forInfoDictionaryKey: kCFBundleVersionKey  as String) as? String ?? ""
    }
    
    static func loadBundle(bundleName:String) -> Bundle? {
        guard let url = Bundle.main.url(forResource: bundleName, withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: url)
    }
    
    static func loadBundleAssets(withName name: String,bundleName: String?="SKIM.bundle") -> String{
        return "\(bundleName!)/\(name)"
    }
    
}
