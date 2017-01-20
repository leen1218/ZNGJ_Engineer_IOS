//
//  Utils.swift
//  ZNGJ
//
//  Created by HuangBing on 1/20/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

func synchronizd(_ lock: AnyObject, closure:()->()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock);
}
