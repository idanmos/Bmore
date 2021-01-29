//
//  Threading.swift
//  B-more
//
//  Created by Idan Moshe on 19/01/2021.
//

import Foundation

func DispatchMainThreadSafe(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}
