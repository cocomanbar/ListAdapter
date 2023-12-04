//
//  ListReusable.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import UIKit

public protocol ListReusable {
    
    static var reuseIdentifier: String { get }
}

public extension ListReusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
