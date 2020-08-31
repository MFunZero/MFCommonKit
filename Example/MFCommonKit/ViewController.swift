//
//  ViewController.swift
//  MFCommonKit
//
//  Created by MFunzero on 11/26/2019.
//  Copyright (c) 2019 MFunzero. All rights reserved.
//

import UIKit
import MFCommonKit
import MFSession

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MFSession.session.test()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        let comment: AppCommont = """
        See \(issue: 123) where \(account: "alisoftware") explains the steps to reproduce.
        """
        print(comment)
        
        let description: AppCommont = "\(issue: 11)"
        print(description)
        
        enum Result<Value, Error> {
            case success(Value)
            case failure(Error)
        }
         
        let result = Result<String, Any>.failure("sss")
        print(result)
//        MFHttpManager.configAuthentication(cerfileName: "star.zdz.la", p12fileNameAndPwd: ["star.zdz.la":"123"])
//        MFHttpManager.sharedInstance.sendRequest(urlString: "https://edurefactor-api.zdz.la/staff/StaffLogin/login", requestMethod: .POST,paras: ["phone":"15639983111","password":"qwer1234"]) { (code, result, success) in
//            print("\(code):\(result)")
//        }

    }
    
}

extension MFSession {
    func test() {
        print("vc.test")
    }
}
