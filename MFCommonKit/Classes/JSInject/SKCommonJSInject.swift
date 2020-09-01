//
//  SKCommonJSInject.swift
//  SKEdu
//
//  Created by iOS-dev on 2019/11/12.
//  Copyright © 2019 shanxidongda. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
 
/// WKWebView js注入使用：
// MARK: -- function必须为@objc声明
@objc class SKCommonJSInject: NSObject {
//
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    weak var webView: WKWebView?
     
}
