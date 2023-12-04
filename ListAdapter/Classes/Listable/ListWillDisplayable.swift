//
//  ListWillDisplayable.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import Foundation

public protocol ListWillDisplayable {
    
    func willDisplay<T, U>(list: T, row: U, indexPath: IndexPath, rowable: any ListDataRowable)
}
