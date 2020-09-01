//
//  BaseWebViewController.swift
//  XJXN
//
//  Created by simple on 2018/11/27.
//  Copyright © 2018年 simple. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController {    
    var URLString: String?
    var HTMLString: String?
    var request: URLRequest?
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(1), width: UIScreen.main.bounds.width, height: 1))
        self.progressView.tintColor = SKTheme.disabledColor      // 进度条颜色
        self.progressView.trackTintColor = UIColor.lightText // 进度条背景色
        return self.progressView
    }()    
    lazy var webView = WKWebView.init(frame: self.view.bounds)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航栏标题颜色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.shadowImage = nil
        webView.backgroundColor = SKTheme.bgColor
        view.addSubview(webView)
        webView.addSubview(progressView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        if let request = self.request {
            webView.load(request)
            return
        }
        
        if let urlString = URLString,
            let sk_URL = URL.init(string: urlString) {
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

//HTML适配图片文字
public func adaptWebViewForHTML(html: String) -> String {
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

extension BaseWebViewController:WKUIDelegate, WKNavigationDelegate,UIWebViewDelegate {
    
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
        
    }
    
}
