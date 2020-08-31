//
//  StringCustom.swift
//  MFCommonKit_Example
//
//  Created by iOS-dev on 2020/3/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

struct AppCommont {
    let markdown: String
}

extension AppCommont: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.markdown = value
    }
}

extension AppCommont: CustomStringConvertible {
    var description: String {
        return self.markdown
    }
}

extension AppCommont: ExpressibleByStringInterpolation {
    struct StringEnterpolation: StringInterpolationProtocol {
        typealias StringLiteralType = String
        var parts: [String]
        init(literalCapacity: Int, interpolationCount: Int) {
            self.parts = []
            self.parts.reserveCapacity(2*interpolationCount+1)
        }
        mutating func appendLiteral(_ literal: String) {
            self.parts.append(literal)
        }
        mutating func appendInterpolation(account name: String) {
            self.parts.append("[\(name)](https://github.com/\(name))")
        }
        mutating func appendInterpolation(issue number: Int) {
          self.parts.append("[#\(number)](issues/\(number))")
        }
    }
    
    init(stringInterpolation: StringEnterpolation) {
        self.markdown = stringInterpolation.parts.joined()
    }
}
