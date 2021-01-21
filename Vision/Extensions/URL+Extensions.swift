//
//  URL+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 08/12/2020.
//

import Foundation

enum Filestatus {
        case file
        case directory
        case notExists
}
extension URL {
    
    var filestatus: Filestatus {
        get {
            let filestatus: Filestatus
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: self.path, isDirectory: &isDir) {
                if isDir.boolValue {
                    // file exists and is a directory
                    filestatus = .directory
                }
                else {
                    // file exists and is not a directory
                    filestatus = .file
                }
            }
            else {
                // file does not exist
                filestatus = .notExists
            }
            return filestatus
        }
    }
    
}
