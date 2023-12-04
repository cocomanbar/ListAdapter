//
//  ListLock.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import Foundation

class ListLock: NSLock {
    
    var isBusy: Bool = false
}
