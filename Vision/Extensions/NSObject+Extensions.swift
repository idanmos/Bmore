//
//  NSObject+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import Foundation

extension NSObject {
    
    class func className() -> String {
        return String(describing: self)
    }
    
    static var propertyNames: [String] {
        var outCount: UInt32 = 0
        guard let ivars = class_copyIvarList(self, &outCount) else {
            return []
        }
        var result = [String]()
        let count = Int(outCount)
        for i in 0..<count {
            let pro: Ivar = ivars[i]
            guard let ivarName = ivar_getName(pro) else {
                continue
            }
            guard let name = String(utf8String: ivarName) else {
                continue
            }
            result.append(name)
        }
        return result
    }
    
}
