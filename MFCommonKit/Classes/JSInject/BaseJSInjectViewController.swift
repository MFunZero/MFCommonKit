//
//  BaseJSInjectViewController.swift
//  JSInject
//
//  Created by iOS-dev on 2019/10/12.
//  Copyright © 2019 iOS-dev. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
 
class BaseJSInjectViewController: UIViewController {
    
    var context: JSContext = JSContext()
    private var commonInject: SKCommonJSInject = SKCommonJSInject()
    private var injectSelectors: [String:Selector] = [:]
    var jsContext: JSContext!
    var URLString: String?
    var editUrlString: String?
    var HTMLString: String?
    var showTitle: Bool = true
    var showEdit: Bool = false
    static var globalTitle: String!
    var token: String?
    var finishBlock:(() -> ())?
    
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(1), width: UIScreen.main.bounds.width, height: 1))
        self.progressView.tintColor = UIColor.lightGray      // 进度条颜色
        self.progressView.trackTintColor = UIColor.lightText // 进度条背景色
        return self.progressView
    }()
    
    lazy var config: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.processPool = WKProcessPool()
        config.userContentController = WKUserContentController()
        //        config.userContentController.add(self, name: "jsInject")
//        setupMsgHandler(config: config)
        return config
    }()
    
    lazy var webView:WKWebView = {
        let webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.backgroundColor = UIColor.white
        return webView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeMsgHandler(config: webView.configuration)
//        IQKeyboardManager.shared().isEnabled = true
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        IQKeyboardManager.shared().isEnabled = false
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupMsgHandler(config: webView.configuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        configUI()
        
    }
    
    func configUI() {
        
        view.addSubview(webView)
         
        if #available(iOS 11.0, *) {
           webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
           // Fallback on earlier versions
        }
        
        if showEdit {
            let rightBarButton = UIBarButtonItem(title: "编辑", style: UIBarButtonItem.Style.plain, target: self, action: #selector(loadEditPage))
            navigationItem.rightBarButtonItem = rightBarButton
        }
        
        //设置导航栏标题颜色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.shadowImage = nil
        
        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.addSubview(progressView)
        webView.backgroundColor = UIColor.white
//        webView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
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
            var request = URLRequest(url: sk_URL)
            // 初始化cookie对象，返回值可选类型
            let cookie = HTTPCookie.init(properties: properties)
            if let cookie = cookie {
                // 保存cookie，地址是沙盒的 /Library/Cookies
                HTTPCookieStorage.shared.setCookie(cookie)
            }
            
            request.addValue("token=\(token)", forHTTPHeaderField: "Cookie")

            webView.load(request)
            return
        }
        
        if let htmlString = HTMLString {
            webView.loadHTMLString(BaseJSInjectViewController.adaptWebViewForHTML(html: htmlString), baseURL: nil)
            return
        }
    }
    
    //HTML适配图片文字
    public static func adaptWebViewForHTML(html: String) -> String {
        let headHTML = NSMutableString.init(capacity: 0)
        headHTML.append("<html>")
        headHTML.append("<head>")
        headHTML.append("<meta charset=\"utf-8\">")
        headHTML.append("<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />")
        headHTML.append("<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />")
        headHTML.append("<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />")
        headHTML.append("<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />")
        //适配图片宽度，让图片宽度等于屏幕宽度
        headHTML.append("<style>img{width:100%;}</style>")
        headHTML.append("<style>img{height:auto;}</style>")
        //适配图片宽度，让图片宽度最大等于屏幕宽度
        headHTML.append("<style>img{max-width:100%;width:auto;height:auto;}</style>")
        //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
        headHTML.append("<script type='text/javascript'>\nwindow.onload = function(){\nvar maxwidth=document.body.clientWidth\nfor(i=0;i <document.images.length;i++){\nvar myimg = document.images[i]\nif(myimg.width > maxwidth){\nmyimg.style.width = '100%'\nmyimg.style.height = 'auto'\n}\n}\n}\n</script>\n")
        headHTML.append("<style>table{width:100%;}</style>")
        headHTML.append("<title>webview</title>")
        var HTMLSting = html
        HTMLSting.append(headHTML as String)
        return HTMLSting
    }
//    override func backAction() {
//        if let block = self.finishBlock {
//            block()
//        }
//        super.backAction()
//    }
    
    deinit {
        webView.stopLoading()
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupMsgHandler(config:WKWebViewConfiguration){
        
        let methods = commonInject.getAllSelector()
        for method in methods {
            let methodName = NSStringFromSelector(method)
            //            let name = methodName.trimmingCharacters(in: CharacterSet.init(charactersIn: ":"))
            if let name = methodName.components(separatedBy: ":").first {
                print(name)
                injectSelectors[name] = method
                config.userContentController.add(self, name: name)
            }
        }
    }
    
    func removeMsgHandler(config:WKWebViewConfiguration){
        
        let methods = commonInject.getAllSelector()
        for method in methods {
            let methodName = NSStringFromSelector(method)
            if let name = methodName.components(separatedBy: ":").first {
                config.userContentController.removeScriptMessageHandler(forName: name)
            }
        }
        
    }
    
}

extension BaseJSInjectViewController: WKUIDelegate, WKNavigationDelegate {
    
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
        } else if keyPath == "title" {
            if showTitle {
                self.title = self.webView.title
            }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
}

extension BaseJSInjectViewController {
    
    @objc func reload() {
        guard let token = self.token, let urlString = URLString,
            let sk_URL = URL.init(string: urlString) else {
                return
        }
        var request = URLRequest(url: sk_URL)
        request.addValue("token=\(token)", forHTTPHeaderField: "Cookie")
        webView.load(request)
    }
    
    @objc func loadEditPage() {
        guard let token = self.token, let urlString = editUrlString,
            let sk_URL = URL.init(string: urlString), urlString.count > 0 else {
//                SKHUDTools.showTextAutomaticDismiss(title: "暂无权限")
                return
        }
         
        var request = URLRequest(url: sk_URL)
        request.addValue("token=\(token)", forHTTPHeaderField: "Cookie")

        webView.load(request)
        navigationItem.rightBarButtonItem?.title = nil
        if showTitle {
            navigationItem.rightBarButtonItem?.title = nil
        }
    }
    
}

extension BaseJSInjectViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("\(message.body),\(message.name)")
        print("thread:\(Thread.current)")
        DispatchQueue.main.async {
            self.commonInject.webView = self.webView
            self.commonInject.controller = self

            if let para = message.body as? String {
                if let sel = self.injectSelectors[message.name] {
                    if para.count > 0 {
                        self.commonInject.perform(sel, with: message.body)
                    } else {
                        self.commonInject.perform(sel)
                    }
                    return
                }
            }
            
            guard let para = message.body as? [Any] else {
                return
            }
            if let sel = self.injectSelectors[message.name] {
                self.commonInject.perform(sel, with: para)
            }
        }
    }
    
}
