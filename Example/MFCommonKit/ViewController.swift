//
//  ViewController.swift
//  MFCommonKit
//
//  Created by MFunzero on 11/26/2019.
//  Copyright (c) 2019 MFunzero. All rights reserved.
//

import UIKit
import MFCommonKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        MFHttpManager.configAuthentication(cerfileName: "star.zdz.la", p12fileNameAndPwd: ["star.zdz.la":"123"])
        MFHttpManager.sharedInstance.sendRequest(urlString: "staff/Staff/pwdLogin", requestMethod: .POST,paras: ["phone":"15639983111","password":"qwer1234"]) { (code, result, success) in
            print("\(code):\(result)")
        }
    }
    
}

