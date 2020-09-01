//
//  BaseViewController.swift
//  Base
//
//  Created by MFun on 2019/6/3.
//  Copyright © 2019 MFun. All rights reserved.
//

import UIKit
@_exported import SHFullscreenPopGestureSwift
@_exported import MJRefresh
import MFCommonKit
//import EmptyPage

//有网络
let SK_NotificationName_Network_Reachability = "SK_NotificationName_Network_Reachability"
//无网络
let SK_NotificationName_Network_NoReachability = "SK_NotificationName_Network_NoReachability"
//监测网络变化
let SK_NotificationName_Network_Reachability_Changed =  "SK_NotificationName_Network_Reachability_Changed"

@objc class BaseViewController: UIViewController {
    
    /// 无网络视图
//    lazy var noNetworkView: EmptyPageView = {
//        let empty = EmptyPageView.ContentView.standard
//            .set(image: SKDefaultsImg.blankImg)
//            .set(title: String.locailizableString(key: "貌似失去网络连接了，请检查手机网络"), color: SKTheme.disabledColor, font: UIFont.sk_font(size: SKTheme.sk_Font_Medium))
//            .change(height: .button, value: 0)
//            .config(imageView: { (item) in
//                item.isUserInteractionEnabled = true
//                item.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(loadData)))
//            })
//            .mix()
//            .set(backgroundColor: SKTheme.selectedColor)
//        return empty
//    }()
    /// 刷新header
    lazy var mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))    
    /// 刷新footer
    lazy var mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadDataDown))
    /// tableView
    lazy var baseTableView: UITableView =  {
        let tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = UIView.AutoresizingMask(rawValue: (UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
//        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.white// UIColor.sk_hexColor("#F6F5F8")
        //        tableView.height = self.view.bounds.height
        //            - self.sk_navHeight - self.sk_tabbarHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        view.insertSubview(tableView, belowSubview: view)
        return tableView
    }()    
    /// emptyView
//    lazy var emptyView: EmptyPageView = {
//        let empty = EmptyPageView.ContentView.standard
//            .set(image: SKDefaultsImg.empty)
//            .set(title: String.locailizableString(key: "没有更多数据~"), color: SKTheme.disabledColor, font: UIFont.sk_font(size: SKTheme.sk_Font_Medium))
//            .change(height: .button, value: 0)
//            .config(imageView: { (item) in
//                item.isUserInteractionEnabled = true
//                item.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(loadData)))
//            })
//            .mix()
//            .set(backgroundColor: SKTheme.bgColor)
//        baseTableView.setEmpty(view: empty)
//        return empty
//    }()
    
    lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage(named: "back"), for: .normal)
        btn.addTarget(self, action: #selector(backAction), for: UIControl.Event.touchUpInside)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("下一步", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.sk_font(size: 18)
//        btn.backgroundColor = SKTheme.mainColor
        btn.setBackgroundImage(SKTheme.mainGradientImage, for: UIControl.State.normal)
        btn.setBackgroundImage(UIImage.createImageWithColor(color: SKTheme.disabledColor), for: UIControl.State.disabled)
        btn.cornerRadius = 22.0
        btn.clipsToBounds = true
        return btn
    }()
    
    var transitionTemp: CATransition?
    // 分页相关
    var page: Int = 1
    // 分页限制
    var limit: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKLog("视图加载：===================》\(self) viewDidLoad")
        view.backgroundColor = SKTheme.bgColor
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        //全屏侧滑
        self.sh_interactivePopDisabled = false
        //        scrollView.sh_scrollViewPopGestureRecognizerEnable = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkNotification), name: NSNotification.Name(rawValue: SK_NotificationName_Network_Reachability), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoNetworkNotification), name: NSNotification.Name(rawValue: SK_NotificationName_Network_NoReachability), object: nil) 
        setupUI()
        setupConstraints()
        addEvents()
    }
    
    @objc func setupUI() {
        
    }    
    @objc func setupConstraints() {    
    }    
    @objc func addEvents() {
        
    }
    
    @objc func backAction() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }else {
            if transitionTemp != nil {
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromLeft
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                self.view.window?.layer.add(transition,forKey: kCATransition)
                self.dismiss(animated: true, completion: nil)
            }else {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    @objc func presentFormRight(vc:BaseViewController,animated: Bool,completion: (() -> Void)?) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        vc.transitionTemp = transition
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.view.window?.layer.add(transition,forKey: kCATransition)
        self.present(vc, animated: animated, completion: nil)
    }
    
    /// 返回到特定页面
    func backTo(viewController: AnyClass) {
        var vc = self.presentingViewController
        if vc != nil {
            while !vc!.isKind(of: viewController){
                vc = vc?.presentingViewController
            }
        }
        (vc as? BaseViewController)?.backAction()
    }
    
    @objc func handleNoNetworkNotification(){
        DispatchQueue.main.async {
            
//            self.noNetworkView.removeFromSuperview()
//            let empty = EmptyPageView.ContentView.standard
//                .set(image: SKDefaultsImg.blankImg)
//                .set(title: String.locailizableString(key: "貌似失去网络连接了，请检查手机网络"), color: SKTheme.disabledColor, font: UIFont.sk_font(size: SKTheme.sk_Font_Medium))
//                .change(height: .button, value: 0)
//                .config(imageView: { (item) in
//                    item.isUserInteractionEnabled = true
//                    item.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.loadData)))
//                })
//                .mix()
//                .set(backgroundColor: UIColor.white)
//            empty.frame = self.view.bounds
//            self.noNetworkView = empty
//            self.view.addSubview(self.noNetworkView)
//            self.view.bringSubviewToFront(self.noNetworkView)
        }
    }    
    @objc func handleNetworkNotification(){
        DispatchQueue.main.async {
//            self.noNetworkView.removeFromSuperview()
        }
    }    
    deinit {
        SKLog("内存释放：===================》\(self) deinit")
    }
    
}

extension BaseViewController {
    ///TODO:-implement
    @objc func loadData() {
        
    }
    
    @objc func loadDataDown() {
        
    }
    
    @objc func rightBarButtionItemClicked(sender: UIBarButtonItem) {
        
    }
    
}

