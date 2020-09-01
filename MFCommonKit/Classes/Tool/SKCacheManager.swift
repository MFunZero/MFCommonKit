//
//  SKCacheManager.swift
//  Base
//
//  Created by MFun on 2019/7/10.
//  Copyright © 2019 MFun. All rights reserved.
//

import Foundation

public class SKCacheManager {    
    public static let cacheManager = SKCacheManager()
    private let cache: NSCache<AnyObject,AnyObject> = NSCache()
    public static var uniqueId: String?
    
    private init() { }    
    var defaultCacheFolder: String? {
//        guard let loginModel = SKUserInfo.readFromUserDefaults(), let userId = loginModel.id else { return  nil }
//        return "cache_default_\(userId)"
        return "cache_default"
    }    
    class func cacheRootFoler() -> String?{
        guard let userId = self.uniqueId else { return  nil }
        return "cacheFolder_\(userId)"
    }    
    class func cacheChildFoler(withType type:String) -> String{
        return "childFolder_\(type)"
    }    
    public final class func defaultDiskCachePathClosure(path: String? = nil, cacheName: String) -> String {
        let dstPath = path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let directory = (dstPath as NSString).appendingPathComponent(cacheName)
        if !FileManager.default.fileExists(atPath: directory) {
            do {
                try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
            }catch let e {
                SKLog(e.localizedDescription)
            }
        }
        return directory
    }
    
}

//数据缓存
public extension SKCacheManager{    
    func saveToDisk(key:String,Value:AnyObject) -> Bool{
        guard let cacheFolder = defaultCacheFolder else { return false }
        let fileFolder = SKCacheManager.defaultDiskCachePathClosure(cacheName: cacheFolder)
        let filePat = "\(fileFolder)/\(key).plist"
//        guard let url = URL(string: filePat) else { return false }
//        Value.write(to: url, atomically: true)
        let success = NSKeyedArchiver.archiveRootObject(Value, toFile: filePat)
        return success
    }    
    func readFromDisk(key:String) -> AnyObject?{
        guard let cacheFolder = defaultCacheFolder else { return nil }
        let fileFolder = SKCacheManager.defaultDiskCachePathClosure(cacheName: cacheFolder)
        let filePat = "\(fileFolder)/\(key).plist"
        let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePat)
        return data as AnyObject
    }
    
    func saveToCache(key:String,Value:AnyObject){
        cache.setObject(Value, forKey: key as AnyObject)
    }
    
    func readFromCache(key:String) -> AnyObject? {
        guard let model = cache.object(forKey: key as AnyObject) else { return nil }
        return model
    }
    //清除缓存
    func clearCache() -> Bool {
        cache.removeAllObjects()
        guard let cacheFolder = defaultCacheFolder else { return false }
        let fileFolder = SKCacheManager.defaultDiskCachePathClosure(cacheName: cacheFolder)
        do {
            try FileManager.default.removeItem(atPath: fileFolder)
        }catch let e {
            SKLog(e.localizedDescription)
            return false
        }
        return true
    }
    
}
