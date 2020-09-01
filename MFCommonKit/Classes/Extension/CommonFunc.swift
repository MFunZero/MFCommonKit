//
//  CommonFunc.swift
//  Base
//
//  Created by iOS-dev on 2019/12/9.
//  Copyright © 2019 MFun. All rights reserved.
//

import Foundation

// MARK:- 自定义打印方法
public func SKLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    NSLog("文件名：\(fileName) | 所在行数:(\(lineNum)) | 内容：\(message)")
    #endif
}

public func  formatTimeToDay(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "zh_CNlet") //中文为zh_CN
    let date2 = dateFormatter.string(from: date)
    return date2
}

public func  formatTimeByFormat(date: Date,dateFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    dateFormatter.locale = Locale(identifier: "zh_CNlet") //中文为zh_CN
    let date2 = dateFormatter.string(from: date)
    return date2
}

public func  formatTimeToDate(time: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "zh_CNlet") //中文为zh_CN
    let date2 = dateFormatter.date(from: time)
    return date2
}

public func formatTimeStrByFormat(date: String,dateFormat: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    dateFormatter.locale = Locale(identifier: "zh_CNlet") //中文为zh_CN
    let date2 = dateFormatter.date(from: date)
    return date2
}

