//
//  ListDidSelectedable.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import Foundation

public protocol ListDidSelectedable {
    
    func didSelected<T, U>(list: T, row: U, indexPath: IndexPath, rowable: any ListDataRowable)
}
