//
//  ListUpdatable.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import Foundation

public protocol ListUpdatable {
    
    func update(with rowable: any ListDataRowable)
}
