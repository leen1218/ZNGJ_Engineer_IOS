//
//  Logger.swift
//  ZNGJ
//
//  Created by HuangBing on 1/21/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class Logger {
    static let debug = true
    
    static func logToConsole(_ format: String, _ args: CVarArg...) {
        if (debug) {
            NSLog(format, args)
        }
    }
}
