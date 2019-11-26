//
//  NSObjectExtension.swift
//  SKEdu
//
//  Created by iOS开发 on 2019/6/4.
//  Copyright © 2019 shanxidongda. All rights reserved.
//

import Foundation

extension NSObject {    
    func getValueOfProperty(property: String) -> AnyObject? {
        let allPropeyties = self.getAllPropertys()
        if allPropeyties.contains(property) {
            return self.value(forKey: property) as AnyObject
        } else {
            return nil
        }
    }    
    func setValueOfProperty(property: String,value: AnyObject) -> Bool {
        let allPropeyties = self.getAllPropertys()
        if allPropeyties.contains(property) {
            self.setValue(value, forKey: property)
            return true
        } else {
            return false
        }
    }    
    func getAllPropertys() -> [String] {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder, &count)
        var propertyNames: [String] = []
        for i in 0..<Int(count) {
            let property = properties![i]
            let name = property_getName(property)
            let strName = String(cString: name)
            propertyNames.append(strName)
        }
        free(properties)
        return propertyNames
    }    
    func getAllKeysValues() -> [[String:AnyObject]] {
        let allPropeyties = self.getAllPropertys()
        var result: [[String:AnyObject]] = []
        for key in allPropeyties {
            if key.compare("description") != ComparisonResult.orderedSame {
                let value = self.value(forKey: key)
                result.append([key: value as AnyObject])
            }
        }
        return result
    }
    
    func getAllSelector() -> [Selector] {
        var count: UInt32 = 0
        var methods: [Selector] = []
        if let methodList = class_copyMethodList(self.classForCoder, &count) {
            for i in 0..<Int(count) {
              let method = method_getName(methodList[i])
              methods.append(method)
            }
            free(methodList)
        }
        return methods
    }
    
}
