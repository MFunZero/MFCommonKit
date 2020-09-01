//
//  SKJSViewController.swift
//  Base
//
//  Created by MFun on 2019/8/20.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit

class SKWebViewController: BaseViewController {
    
    var URLString: String?
    var editUrlString: String?
    var HTMLString: String?
    var token: String?
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(1), width: UIScreen.main.bounds.width, height: 1))
        self.progressView.tintColor = SKTheme.disabledColor      // 进度条颜色
        self.progressView.trackTintColor = UIColor.lightText // 进度条背景色
        return self.progressView
    }()
    
    lazy var config: WKWebViewConfiguration = {
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        let config = WKWebViewConfiguration()
        config.preferences = preference
        config.userContentController = WKUserContentController()
        //        config.userContentController.add(self, name:"jsInject")
        config.userContentController.add(self, name:"Appfinish")
        
        return config
    }()
    
    lazy var webView: WKWebView = {
        let webView =  WKWebView(frame: CGRect.init(x: 0, y: 0, width:UIScreen.sk_ScreenWidth() , height: UIScreen.sk_ScreenHeight()-sk_navHeight), configuration: config)
        return webView
    }()
    
    var showEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showEdit {
            let rightBarButton = UIBarButtonItem(title: "编辑", style: UIBarButtonItem.Style.plain, target: self, action: #selector(loadEditPage))
            navigationItem.rightBarButtonItem = rightBarButton
        }
        
        //设置导航栏标题颜色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.shadowImage = nil
        
        view.addSubview(webView)
        webView.addSubview(progressView)
        
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
         
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        guard let token = self.token else { return }
        if let urlString = URLString,
            let sk_URL = URL.init(string: urlString), let host = sk_URL.host {
            // 过期时间1年
            let expires: TimeInterval = 60 * 60 * 24
            
            // 定义一个可变字典存放cookie键值对
            var properties: [HTTPCookiePropertyKey : Any] = [:]
            properties[.name] = "token"
            properties[.path] = "/"
            properties[.value] = token
            properties[.secure] = false
            properties[.domain] = host
            properties[.version] = 0
            properties[.expires] = Date.init(timeIntervalSinceNow: expires)
            
            // 初始化cookie对象，返回值可选类型
            let cookie = HTTPCookie.init(properties: properties)
            if let cookie = cookie {
                // 保存cookie，地址是沙盒的 /Library/Cookies
                HTTPCookieStorage.shared.setCookie(cookie)
            }
//            webView.load(URLRequest.init(url: sk_URL))
            webView.load(URLRequest.init(url: sk_URL))
            return
        }
        
       
        if let htmlString = HTMLString {
            webView.loadHTMLString(adaptWebViewForHTML(html: htmlString), baseURL: nil)
            return
        }
        
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
    }
    
}

extension SKWebViewController: WKUIDelegate,WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //  加载进度条
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        
    }
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { [weak self](title, error) in
            self?.title = title as? String
        }
    }
    
}

extension SKWebViewController {
    
    @objc func loadEditPage() {
        guard let urlString = editUrlString,
            let sk_URL = URL.init(string: urlString) else {
                return
        }
//        webView.load(URLRequest.init(url: sk_URL))
        webView.load(URLRequest.init(url: sk_URL))
        navigationItem.rightBarButtonItem?.title = nil
    }
    
    @objc func getScriptType(){
        
    }
    
}

extension SKWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
}
