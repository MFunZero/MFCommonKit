//
//  MFSession.swift
//  MFCommonKit_Example
//
//  Created by iOS-dev on 2020/3/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire
 
public class MFSession {
    
    public enum Result<Value, Error> {
        case success(Value,Value)
        case failure(Error)
    }
    
    public static let session: MFSession = MFSession()
    
    init() {
        
    }
    
    public func test() {
        print("MFSession test")
        let result = Result<Any, Int>.failure(404)
        guard case let Result.failure(error) = result else { return }
        print(error)
        guard case let Result.success(value) = result else { return }
        print(value)
    }
    
    ////发送请求
    public func sendRequest(urlString: String,method: HTTPMethod = .post, paras: [String: Any]? = nil, requsetHeaders: HTTPHeaders? = nil, finished: @escaping ((Result<Any, Any>) ->())){
        
        let encode: ParameterEncoding = URLEncoding.default
        //请求成功的回调闭包
        let completionCallBack = finished
        
        //请求
        AF.request(urlString, method: method, parameters: paras, encoding: encode, headers: requsetHeaders)
            .responseJSON {(response) in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode,
                        let returnData = response.value as? [String: Any] else {  completionCallBack(Result.failure(response.response?.statusCode ?? Result<Any, String>.failure("statusCode 未知")))
                            return
                    }
                    completionCallBack(Result.success(returnData,statusCode))
                case .failure:
                   completionCallBack(Result.failure(response.response?.statusCode ?? Result<Any, String>.failure("statusCode 未知")))
                }
        }
        
        print("\(urlString):\(String(describing: paras))")
        
    }
    
}
