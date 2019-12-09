//
//  MFHttpManager.swift
//  MFEdu
//
//  Created by iOS开发 on 2019/5/31.
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

public enum MFRequestMethodType {
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

public class MFHttpManager {
    fileprivate static var trustFileNameOfP12: String = " "
    fileprivate static var trustFilePwdOfP12: String = "123"
    fileprivate static var trustFileNameOfCer: String = " "
    fileprivate static var enableHttps: Bool = false
 
    fileprivate var resultDict:[String:Any] = [:]
    public static let sharedInstance = MFHttpManager()
    private let MFTimeout: TimeInterval = 30
    private lazy var manager: SessionManager = {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = MFTimeout
        return SessionManager(configuration: config, delegate: SessionDelegate(), serverTrustPolicyManager: nil)
    }()
    
    
    private init() {
        if MFHttpManager.enableHttps {
            setHttps()
        }
    }
    
    private func setHttps() {

        manager.delegate.sessionDidReceiveChallenge = { [weak self] session, challenge in
            //认证服务器（这里不使用服务器证书认证，只需地址是我们定义的几个地址即可信任）
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust
            {
                print("服务器认证！")
            //                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            //                return (.useCredential, credential)
                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
                let remoteCertificateData
                = CFBridgingRetain(SecCertificateCopyData(certificate))!
                let cerPath = Bundle.main.path(forResource: MFHttpManager.trustFileNameOfCer, ofType: "cer")!
                let cerUrl = URL(fileURLWithPath:cerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)

                if (remoteCertificateData.isEqual(localCertificateData) == true) {
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return (.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!));
                } else {
                   return (.cancelAuthenticationChallenge, nil)
                }
            }//认证客户端证书
            else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate {
                print("客户端证书认证！")
                //获取客户端证书相关信息
                if let identityAndTrust:IdentityAndTrust = self?.extractIdentity() {
                    let urlCredential:URLCredential = URLCredential(
                        identity: identityAndTrust.identityRef,
                        certificates: identityAndTrust.certArray as? [AnyObject],
                        persistence: URLCredential.Persistence.forSession);
                    
                    return (.useCredential, urlCredential);
                } else {
                    return (.cancelAuthenticationChallenge, nil)
                } 
            }  else { // 其它情况（不接受认证）
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    //获取客户端证书相关信息
    private func extractIdentity() -> IdentityAndTrust? {
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: MFHttpManager.trustFileNameOfP12, ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : MFHttpManager.trustFilePwdOfP12] //客户端证书密码
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
    public func sendRequest(urlString: String,requestMethod: MFRequestMethodType = .GET, paras: [String: Any]? = nil, requsetHeaders: HTTPHeaders? = nil, isShowHUD: Bool? = true, finished: @escaping (( _ statusCode: Int?, _ result: Any?, _ isSuccess: Bool) ->())){
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
        let request = manager.request(urlString, method: method, parameters: paras, encoding: encode, headers: requsetHeaders)
            .responseJSON {(response) in
                //请求成功
                response.result.ifSuccess {
                    guard let statusCode = response.response?.statusCode,
                        let returnData = response.value as? [String: Any] else {
                            completionCallBack(response.response?.statusCode, response.error, false)
                            return
                    }
                    
                    completionCallBack(statusCode, returnData, true)
                }
                response.result.ifFailure {
                    completionCallBack(response.response?.statusCode, response.error, false)
                }
        }
        
        print("\(request):\(String(describing: paras))")
        
    }    
    public func uploadWithPara(urlString: String,requestHeaders:[String:String]?,file:Data,fileName:String,completionCallBack: @escaping (( _ statusCode: Int?, _ result: Any?, _ isSuccess: Bool) ->())) {
        
        guard let headers:[String:String] = requestHeaders else {
            return
        }
        
        manager.upload(multipartFormData: { (multiPart) in
            multiPart.append(file, withName: "file", fileName: fileName, mimeType: "image/png")
        }, to: urlString, headers: ["cookie":"\(headers.keys.first!)=\(headers.values.first!)"]) { (result) in
            switch result {
            case .failure(let error):
                completionCallBack(error._code, error, false)
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    guard  let returnData = response.value as? [String: Any],let statusCode = returnData["code"] as? Int else {
                            completionCallBack(response.response?.statusCode, response.error, false)
                            return
                    }
                    completionCallBack(statusCode, returnData, true)
                })
            }
        }
        print(urlString+":\(headers)")
    }
    
    //单片上传
    public func uploadWithSplit(urlString: String,headers:[String:String]?,parameters:[String:Any],file:Data,fileName:String,mimeType:String = "image/png", progressBlock:((Double) -> ())? = nil, completionCallBack: @escaping (( _ statusCode: Int?, _ result: Any?, _ isSuccess: Bool) ->()) ){
        
        Alamofire.upload(multipartFormData: { (multiPart) in
            multiPart.append(file, withName: "file", fileName: fileName, mimeType: mimeType)
            // 其余参数绑定
            for (key, value) in parameters{
                if let valueString = value as? String, let data = valueString.data(using: String.Encoding.utf8){
                    multiPart.append(data, withName: key)
                    print("Para:\(key),\(value) \n")
                }
            }
        },to: (urlString), headers: headers) { (result) in
            switch result {
            case .failure(let error):
                completionCallBack(error._code, error, false)
            case .success(let upload, _, _):
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("progress:\(progress)")
                    if let block = progressBlock {
                        block(progress.fractionCompleted)
                    }
                }
                upload.responseJSON(completionHandler: { (response) in
                    guard let statusCode = response.response?.statusCode,
                        let returnData = response.value as? [String: Any],let code = returnData["code"] as? Int else {
                            completionCallBack(response.response?.statusCode, response.error, false)
                            return
                    }
                    if statusCode == 200 {
                        //请求成功
                        completionCallBack(code, returnData, true)
                    } else {
                        completionCallBack(code, returnData, false)
                    }
                    
                })
            }
        }
    }
    
    /// 泛型解析数据转换为特定类型
    public static func uploadWithSplitCommon<T:HandyJSON>(urlString: String,uniqueTag:String? = nil, requsetHeaders: [String:String]? = nil,paras:[String:Any]?,splitype:MFSplitType? = MFSplitType.img, fileExt: String, file: Data? = nil, responseType: T.Type, isShowHUD: Bool? = true, completionCallBack: @escaping (( _ statusCode: Int?, _ result: Any?, _ isSuccess: Bool) ->())){
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
                MFHttpManager.sharedInstance.uploadWithSplit(urlString: urlString, headers: requsetHeaders, parameters: paraInner, file: block, fileName: fileName,mimeType: priMimeType) { (code, result, isSuccess) in
                    if let json = result as? [String:Any],let jsonResult = json["data"] as? Int,let resultCode = code, resultCode == 0 {
                        
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
                if let model = resultArray["success"] as? Bool {
                    if let uuid = resultArray["id"] as? Int {
                        completionCallBack(0,uuid,true)
                        print("切片上传成功")
                        return
                    }
                    completionCallBack(0,model,false)
                } else {
                    completionCallBack(1,nil,false)
                }
            }
        }
            
    }
     
}
 
extension MFHttpManager {
    
    public static func configAuthentication(cerfileName: String?,p12fileNameAndPwd: [String:String]?) {
        
        if let cer = cerfileName {
            MFHttpManager.trustFileNameOfCer = cer
            MFHttpManager.enableHttps = true
        }
        if let p12 = p12fileNameAndPwd, let name = p12.keys.first, let pwd = p12.values.first {
            MFHttpManager.trustFileNameOfP12 = name
            MFHttpManager.trustFilePwdOfP12 = pwd
            MFHttpManager.enableHttps = true
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
