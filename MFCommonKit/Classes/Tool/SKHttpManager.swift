//
//  SKHttpManager.swift
//  MFEdu
//
//  Created by MFun on 2019/5/31.
//  Copyright © 2019 MFun. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON

//定义一个结构体，存储认证相关信息
public struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}

public enum SKRequestMethodType: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public enum ResponseResultType: String {
    case Success = "请求成功"
    case Failed = "请求失败"
    /// code 不存在
    case Unknown = "未知错误：010"
    /// msg解析错误
    case Unknown1 = "未知错误：011"
    /// code != 200 且msg解析失败
    case Unknown2 = "未知错误：012"
    /// 请求超时
    case Unknown3 = "未知错误：013"
}

public enum MFSplitType {
    case img,video,audio,file
}

let SplitUploadMaxSize = 1024 * 1024

enum SKHttpsTrustType: Int {
    case  none,ignore, cer
}

public class SKHttpManager: SessionDelegate {
    
    fileprivate static var trustFileNameOfP12: String = " "
    fileprivate static var trustFilePwdOfP12: String = "123"
    fileprivate static var trustFileNameOfCer: String = " "
    fileprivate static var trustType: SKHttpsTrustType = .ignore
    
    fileprivate var resultDict:[String:Any] = [:]
    public static let sharedInstance = SKHttpManager()
    private let MFTimeout: TimeInterval = 10
    
    private lazy var manager: Session = {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = MFTimeout
        return Session(configuration: config, delegate: self, serverTrustManager: nil)
    }()
    
    
    private init() {
        AF.sessionConfiguration.timeoutIntervalForRequest = MFTimeout
    }
    
    //获取客户端证书相关信息
    private func extractIdentity() -> IdentityAndTrust? {
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: SKHttpManager.trustFileNameOfP12, ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : SKHttpManager.trustFilePwdOfP12] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess {
            let certItems:CFArray = items!
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"]
                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity
                print("\(String(describing: identityPointer))  :::: \(secIdentityRef)")
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                print("\(String(describing: trustPointer))  :::: \(trustRef)")
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                    trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust
    }
    
    
    ////发送请求
    public func sendRequest(urlString: String,requestMethod: SKRequestMethodType = .GET, paras: [String: Any]? = nil, requestHeaders: HTTPHeaders? = nil, isShowHUD: Bool? = true, finished: @escaping (( _ statusCode: Int?, _ result: Any?, _ isSuccess: Bool) ->())){
        var method: HTTPMethod {
            switch requestMethod {
            case .GET:
                return .get
            case .PUT:
                return .put
            case .DELETE:
                return .delete
            case .POST:
                return .post
            }
        }
        
        let encode: ParameterEncoding = URLEncoding.default
        //请求成功的回调闭包
        let completionCallBack = finished
        
        //请求
        _ = manager.request(urlString, method: method, parameters: paras, encoding: encode, headers: requestHeaders)
            .responseJSON {(response) in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode,
                        let returnData = response.value as? [String: Any] else {
                            completionCallBack(response.response?.statusCode, response.error, false)
                            return
                    }
                    
                    completionCallBack(statusCode, returnData, true)
                case .failure:
                    completionCallBack(response.response?.statusCode, response.error, false)
                }
        }
        
        print("\(urlString):\(String(describing: paras))")
        
    }
    public func uploadWithPara(urlString: String,requestHeaders:[String:String]?,file:Data,fileName:String,completionCallBack: @escaping (( _ statusCode: Int?, _ result: Any?, _ isSuccess: Bool) ->())) {
        
        guard let headers:[String:String] = requestHeaders else {
            return
        }
        
        manager.upload(multipartFormData: { (multiPart) in
            multiPart.append(file, withName: "file", fileName: fileName, mimeType: "image/png")
        }, to: urlString, headers: HTTPHeaders(headers)).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completionCallBack(error._code, error, false)
            case .success( _):
                guard  let returnData = response.value as? [String: Any],let statusCode = returnData["code"] as? Int else {
                    completionCallBack(response.response?.statusCode, response.error, false)
                    return
                }
                completionCallBack(statusCode, returnData, true)
            }
        }
        print(urlString+":\(headers)")
    }
    
    
    /// 多文件上传
    /// - Parameters:
    ///   - urlString: 上传地址url
    ///   - requestHeaders: 请求头
    ///   - files: 文件数组
    ///   - fileNames: 文件名数组
    ///   - mimeTypes: 文件类型
    ///   - completionCallBack: 操作结果回调
    public func uploadMultiDataWithPara(urlString: String,requestHeaders:HTTPHeaders?,parameters:[String:Any],files:[Data],fileNames:[String],mimeTypes:[String] = [],completionCallBack: @escaping (( _ statusCode: Int?, _ result: Any?, _ isSuccess: Bool) ->())) {
        
        assert(files.count == fileNames.count, "文件和文件名数量不匹配")
        
        manager.upload(multipartFormData: { (multiPart) in
            
            for (i,file) in files.enumerated() {
                if mimeTypes.count >= files.count {
                    multiPart.append(file, withName: "files[\(i)]", fileName: fileNames[i], mimeType: mimeTypes[i])
                } else {
                    multiPart.append(file, withName: "files[\(i)]", fileName: fileNames[0], mimeType: "image/png")
                }
            }
            // 其余参数绑定
            for (key, value) in parameters{
                if let valueString = value as? String, let data = valueString.data(using: String.Encoding.utf8){
                    multiPart.append(data, withName: key)
                    print("Para:\(key),\(value) \n")
                }
            }
        }, to: urlString, headers: requestHeaders).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completionCallBack(error._code, error, false)
            case .success( _):
                guard  let returnData = response.value as? [String: Any],let statusCode = returnData["code"] as? Int else {
                    completionCallBack(response.response?.statusCode, response.error, false)
                    return
                }
                completionCallBack(statusCode, returnData, true)
            }
        }
        print(urlString+":\(String(describing: requestHeaders))")
    }
    
    //单片上传
    public func uploadWithSplit(urlString: String,headers:[String:String]?,parameters:[String:Any],file:Data,fileName:String, typeName: String = "file", mimeType:String = "image/png", progressBlock:((Double) -> ())? = nil, completionCallBack: @escaping (( _ statusCode: Int?, _ result: Any?, _ isSuccess: Bool) ->()) ){
        
        AF.upload(multipartFormData: { (multiPart) in
            multiPart.append(file, withName: typeName, fileName: fileName, mimeType: mimeType)
            // 其余参数绑定
            for (key, value) in parameters{
                if let valueString = value as? String, let data = valueString.data(using: String.Encoding.utf8){
                    multiPart.append(data, withName: key)
                    print("Para:\(key),\(value) \n")
                }
            }
        }, to: urlString, headers: HTTPHeaders(headers ?? [:]))
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    completionCallBack(error._code, error, false)
                case .success( _):
                    guard let statusCode = response.response?.statusCode,
                        let returnData = response.value as? [String: Any],let code = returnData["code"] as? Int else {
                            completionCallBack(response.response?.statusCode, response.error, false)
                            return
                    }
                    print("returnData:\(returnData)")
                    if statusCode == 200 {
                        //请求成功
                        completionCallBack(code, returnData, true)
                    } else {
                        completionCallBack(code, returnData, false)
                    }
                }
        }
        .uploadProgress(queue: DispatchQueue.main) { (progress) in
            print("progress:\(progress)")
            if let block = progressBlock {
                block(progress.fractionCompleted)
            }
        }
        
    }
    /// 泛型解析数据转换为特定类型
    public static func uploadWithSplitCommon<T:HandyJSON>(urlString: String,uniqueTag:String? = nil, requestHeaders: [String:String]? = nil,paras:[String:Any]?,splitype:MFSplitType? = MFSplitType.img, fileExt: String, file: Data? = nil, responseType: T.Type, isShowHUD: Bool? = true, completionCallBack: @escaping (( _ statusCode: Int?, _ result: Any?, _ isSuccess: Bool) ->())){
        guard let splitType = splitype, let fileData = file else {
            print("切片上传，未读取到相应文件")
            return
        }
        
        let totalSize = (fileData as NSData).length
        let blockCount = totalSize%SplitUploadMaxSize == 0 ? (totalSize/SplitUploadMaxSize):(totalSize/SplitUploadMaxSize+1)
        var parameters:[String: Any] = [:]
        if let pa = paras{
            parameters = pa
        }
        parameters["chunks"] = "\(blockCount)"
        parameters["size"] = "\(totalSize)"
        
        var priMimeType = "image/png"
        var ext = fileExt
        switch splitType {
        case .img:
            break
        case .video:
            ext = "mp4"
            priMimeType = "application/octet-stream"
        default:
            priMimeType = "application/octet-stream"
        }
        
        let fileName = "\(String.randomStr(len: 19))\(ext)"
        parameters["name"] = fileName
        let inputStream:InputStream = InputStream(data: fileData)
        var myBuffer = [UInt8](repeating:0, count: SplitUploadMaxSize)
        inputStream.open()
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: String.randomStr(len: 19))
        
        var resultArray:[String:Any?] = ["success":false,"id":nil]
        for i in 0..<blockCount {
            parameters["chunk"] = "\(i)"
            let bytesRead = inputStream.read(&myBuffer, maxLength: SplitUploadMaxSize)
            let block = Data(bytes: &myBuffer, count: bytesRead)
            let fileName = "\(String.randomStr(len: 19))_chunk_\(i)\(ext)"
            
            let paraInner = parameters
            workingGroup.enter()
            workingQueue.async {
                SKHttpManager.sharedInstance.uploadWithSplit(urlString: urlString, headers: requestHeaders, parameters: paraInner, file: block, fileName: fileName,mimeType: priMimeType) { (code, result, isSuccess) in
                    if let json = result as? [String:Any],let jsonResult = json["data"] as? [String: Any],let resultCode = code, resultCode == 0 {
                        let tempModel = JSONDeserializer<T>.deserializeFrom(dict: jsonResult)
                        resultArray["id"] = tempModel
                        resultArray["success"] = true
                    } else if let json = result as? [String:Any],let jsonResult = json["data"] as? Int,let resultCode = code, resultCode == 0 {
                        
                        resultArray["id"] = jsonResult
                        resultArray["success"] = true
                    }
                    workingGroup.leave()
                }
            }
        }
        inputStream.close()
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async {
                print("workingQueue end")
                if let success = resultArray["success"] as? Bool, success {
                    if let uuid = resultArray["id"] as? Int {
                        completionCallBack(0,uuid,true)
                        SKLog("切片上传成功")
                        return
                    } else if let uuid = resultArray["id"] as? T {
                        completionCallBack(0,uuid,true)
                        SKLog("切片上传成功")
                        return
                    }
                    SKLog("切片上传失败")
                    completionCallBack(0,nil,false)
                } else {
                    SKLog("切片上传失败")
                    completionCallBack(1,nil,false)
                }
            }
        }
    }
    
    ///下载
    
    /// 下载文件到指定位置
    /// - Parameters:
    ///   - url: 下载地址
    ///   - destUrl: 目标路径，包含文件名
    ///   - callBack: 下载结果回调
    public static func downloadFile(url: String, destUrl: NSURL, callBack:@escaping((NSURL?, Bool) -> Void), progressCallBack:@escaping((CGFloat)->())) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (destUrl as URL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(url, to: destination)
            .downloadProgress { (progress) in
               let completed = progress.completedUnitCount
               let total = progress.totalUnitCount
            progressCallBack(CGFloat(completed/total))
        }.responseData { (response) in
            switch response.result {
            case .success:
                callBack(destUrl,true)
            case .failure(let e):
                ///response.resumeData 意外终止时已下载数据
                SKLog(e.localizedDescription)
                callBack(destUrl,false)
            }
        }
    }
    
}

extension SKHttpManager {
    
    public static func configAuthentication(cerfileName: String?,p12fileNameAndPwd: [String:String]?) {
        
        if let cer = cerfileName {
            SKHttpManager.trustFileNameOfCer = cer
            SKHttpManager.trustType = .cer
        }
        if let p12 = p12fileNameAndPwd, let name = p12.keys.first, let pwd = p12.values.first {
            SKHttpManager.trustFileNameOfP12 = name
            SKHttpManager.trustFilePwdOfP12 = pwd
            SKHttpManager.trustType = .cer
        }
        
    }
    
}

extension SKHttpManager {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if SKHttpManager.trustType == .ignore {
            completionHandler(.useCredential, nil)
            return
        } else if SKHttpManager.trustType == .none {
            completionHandler(.rejectProtectionSpace, nil)
            return
        }
        //认证服务器（这里不使用服务器证书认证，只需地址是我们定义的几个地址即可信任）
        if challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodServerTrust
        {
            print("服务器认证！")
            //                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            //                return (.useCredential, credential)
            let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
            let remoteCertificateData
                = CFBridgingRetain(SecCertificateCopyData(certificate))!
            let cerPath = Bundle.main.path(forResource: SKHttpManager.trustFileNameOfCer, ofType: "cer")!
            let cerUrl = URL(fileURLWithPath:cerPath)
            let localCertificateData = try! Data(contentsOf: cerUrl)
            
            if (remoteCertificateData.isEqual(localCertificateData) == true) {
                let credential = URLCredential(trust: serverTrust)
                challenge.sender?.use(credential, for: challenge)
                completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!));
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }//认证客户端证书
        else if challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodClientCertificate {
            print("客户端证书认证！")
            //获取客户端证书相关信息
            if let identityAndTrust:IdentityAndTrust = self.extractIdentity() {
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                completionHandler(.useCredential, urlCredential);
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }  else { // 其它情况（不接受认证）
            print("其它情况（不接受认证）")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
    }
    
}

extension String{
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    public static func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
}

